# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

  mapping do
    indexes :id, index: :not_analyzed
    indexes :username, analyzer: 'snowball'
    indexes :displayname, analyzer: 'snowball', boost: 10
    indexes :professional_bio, analyzer: 'snowball'
    indexes :skills do
      indexes :name, analyzer: 'keyword'
    end
    indexes :languages do
      indexes :name, analyzer: 'keyword'
    end
  end

  def to_indexed_json
    to_json( include: {
      skills: { only: [:name] },
      languages: { only: [:name] }
    })
  end

  attr_accessible :phone, :cell_phone, :professional_bio, :status_message, :avatar,
      :role_ids, :feed_ids, :feeds, :shortcut_ids, :shortcuts,
      :language_list, :skill_list,
      :private_bio, :twitter, :skype, :homepage, :company_short,
      :room, :address, :district, :post_code, :postal_town, :geo_position_x, :geo_position_y

  attr_accessible :phone, :cell_phone, :professional_bio, :status_message, :avatar,
      :role_ids, :feed_ids, :feeds, :shortcut_ids, :shortcuts,
      :language_list, :skill_list,
      :private_bio, :twitter, :skype, :homepage, :company_short,
      :room, :address, :district, :post_code, :postal_town, :geo_position_x, :geo_position_y,
      :admin, :contacts_editor, :early_adopter, as: :admin

  attr_accessor :avatar
  attr_reader :avatar_remote_url

  default_scope { where(deactivated: false) }

  has_and_belongs_to_many :roles
  has_and_belongs_to_many :feeds
  has_and_belongs_to_many :shortcuts
  has_many :user_agents, dependent: :destroy
  has_many :subordinates, class_name: "User", foreign_key: :manager_id, order: :first_name
  belongs_to :manager, class_name: "User"
  has_many :user_languages
  has_many :languages, through: :user_languages
  has_many :user_skills
  has_many :skills, through: :user_skills

  has_many :colleagueships, dependent: :destroy
  has_many :colleagues, through: :colleagueships
  has_many :inverse_colleagueships, class_name: "Colleagueship", foreign_key: "colleague_id", dependent: :destroy
  has_many :inverse_colleagues, through: :inverse_colleagueships, source: :user

  # Paperclip image, options is in the Paperclip initializer
  has_attached_file :avatar
  before_post_process :validate_avatar_file_size

  validates_uniqueness_of :username
  validates :roles, presence: { message: "Du måste välja minst en förvaltning och ett arbetsfält" }
  validates_presence_of :username
  validates_length_of :professional_bio, :private_bio, maximum: 400
  validates_length_of :skype, :twitter, :room, :address, maximum: 64
  validates_length_of :homepage, maximum: 255

  before_validation do
    self.homepage = "http://#{homepage}" unless homepage.blank? || homepage.match(/^https?:\/\//)
    self.twitter = twitter.gsub(/^@/, "").downcase unless twitter.blank?
  end

  after_validation do
    # Explicit validation for accociated models. `validates_associated` will not do.
    errors.add(:skill_list, "Max 48 tecken per kompetensområde") if @skill_errors
    errors.add(:language_list, "Max 48 tecken per språknamn") if @language_errors
  end

  after_create do
    # Map CMG ID when account is created
    update_attribute(:cmg_id, AastraCWI.get_cmg_id(self))
  end

  validates_attachment_content_type :avatar,
    content_type: ['image/tiff', 'image/jpeg', 'image/pjpeg', 'image/jp2'],
    message: "Fel bildformat. Du kan ladda upp en jpeg- eller tiff-bild"

  validates_attachment_size :avatar,
    less_than: 4.megabyte,
    message: "Bilden får inte vara större än 4MB."

  def company_short
    company.gsub(/^[\d\s]*/, "") if company.present?
  end

  # language names as tokens
  def language_list
    languages.map(&:name).join(", ")
  end

  def language_list=(names)
    self.languages = names.split(",").map do |n|
      l = Language.where(name: n.strip).first_or_create
      # Explicit validation for accociated model
      if l.valid?
        l
      else
        @language_errors = true
        nil
      end
    end.compact
  end

  # Skill names as tokens
  def skill_list
    skills.map(&:name).join(", ")
  end

  def skill_list=(names)
    self.skills = names.split(",").map do |n|
      s = Skill.where(name: n.strip).first_or_create
      # Explicit validation for accociated model
      if s.valid?
        s
      else
        @skill_errors = true
        nil
      end
    end.compact
  end

  # Get users feeds in a given category
  # A user has feeds directly and through her roles
  def feeds_in_category(category)
    user_selected = feeds.where(category: category).pluck(:id)
    through_roles = roles.where('feeds.category' => category).includes(:feeds).select(:id).map {|r| r.feeds.map(&:id) }
    (user_selected + through_roles).flatten.uniq
  end

  # Select feed_entries from the users feeds in a given category
  def feed_entries_in_category(category, options = {})
    options = { limit: 5, before: Time.now }.merge(options)

    # Select the latest feed_entries. Or (used for "load more") those published before options[:before]
    FeedEntry.where("feed_id IN (?) AND published_at < ?", feeds_in_category(category), options[:before])
      .group(:guid)
      .includes(:feed)
      .order("published_at DESC")
      .limit(options[:limit]).each { |e| e.full = YAML.load e.full }
  end

  def shortcuts_in_category(category)
    through_roles = roles.where('shortcuts.category' => category).includes(:shortcuts).map {|r| r.shortcuts }
    my_own = shortcuts.map { |s| s if s.category == category }
    (my_own.compact + through_roles).flatten.uniq.sort { |a, b| a.name <=> b.name }
  end

  # Sort colleagues by their status_message_updated_at
  def sorted_colleagues
    # Filter deactivated colleagues (users)
    c = colleagueships.includes(:colleague).reject { |cs| cs.colleague.blank? }

    c.sort do |a,b|
      ( b.colleague.status_message_updated_at && a.colleague.status_message_updated_at ) ?
      b.colleague.status_message_updated_at <=> a.colleague.status_message_updated_at : ( a.colleague.status_message_updated_at ? -1 : 1 )
    end
  end

  def self.search(query, limit = 25, offset = 0)
    return {} if query.empty?
    users = User.scoped
    query[:q] ||=  query[:term]
    if query[:q].present?
      q = "#{query[:q]}%"
      users = users.where("username LIKE ? OR first_name LIKE ? OR last_name LIKE ? OR
          concat_ws(' ', first_name, last_name) LIKE ? OR email LIKE ?", q, q, q, q, q)
    end
    users = users.where(company: query[:company]) if query[:company].present?
    users = users.where(department: query[:department]) if query[:department].present?
    users = users.where("skills.name" => query[:skill]).includes(:skills) if query[:skill].present?
    users = users.where("languages.name" => query[:language]).includes(:languages) if query[:language].present?
    { users: users.order(:first_name).limit(limit).offset(offset), total: users.count }
  end

  private

  # Validate avatar before scaling it
  def validate_avatar_file_size
    valid? && errors.messages.blank?
  end
end
