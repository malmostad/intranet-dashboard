# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  include EmployeeSearch

  attr_accessible :phone, :cell_phone, :professional_bio, :status_message, :avatar,
      :role_ids, :feed_ids, :feeds, :shortcut_ids, :shortcuts, :combined_feed_stream,
      :language_list, :skill_list, :activity_list,
      :private_bio, :twitter, :skype, :linkedin, :homepage, :company_short,
      :room, :address, :district, :post_code, :postal_town, :geo_position_x, :geo_position_y

  attr_accessible :admin, :contacts_editor, :early_adopter, as: :admin
  accessible_attributes(:admin).merge(accessible_attributes)

  attr_accessor :avatar
  attr_reader :avatar_remote_url

  default_scope { where(deactivated: false) }

  has_and_belongs_to_many :roles
  has_and_belongs_to_many :feeds
  has_and_belongs_to_many :shortcuts
  has_many :user_agents, dependent: :destroy
  has_many :subordinates, -> { order(:first_name) }, class_name: "User", foreign_key: :manager_id
  belongs_to :manager, class_name: "User"
  has_many :user_languages
  has_many :languages, through: :user_languages
  has_many :user_skills
  has_many :skills, through: :user_skills
  has_many :user_activities
  has_many :activities, through: :user_activities

  has_many :colleagueships, dependent: :destroy
  has_many :colleagues, through: :colleagueships
  has_many :inverse_colleagueships, class_name: "Colleagueship", foreign_key: "colleague_id", dependent: :destroy
  has_many :inverse_colleagues, through: :inverse_colleagueships, source: :user

  # Paperclip image, options is in the Paperclip initializer
  has_attached_file :avatar
  before_post_process :validate_avatar_file_size

  validates_uniqueness_of :username
  validates_presence_of :username
  validate :validate_roles, on: :update
  validates_length_of :professional_bio, :private_bio, maximum: 400
  validates_length_of :skype, :twitter, :linkedin, :room, :address, maximum: 64
  validates_length_of :homepage, maximum: 255

  def validate_roles
    if roles.where(category: "department").empty?
      errors.add(:department, "Du måste välja minst en förvaltning")
    end

    if roles.where(category: "working_field").empty?
      errors.add(:working_field, "Du måste välja minst ett arbetsfält")
    end
  end

  before_validation do
    self.homepage = "http://#{homepage}" unless homepage.blank? || homepage.match(/^https?:\/\//)
    self.linkedin = "https://#{linkedin}" unless linkedin.blank? || linkedin.match(/^https?:\/\//)
    self.twitter = twitter.gsub(/^@/, "").downcase unless twitter.blank?
  end

  after_validation do
    # Explicit validation for accociated models. `validates_associated` will not do.
    errors.add(:skill_list, "Max 48 tecken per kompetensområde") if @skill_errors
    errors.add(:activity_list, "Max 48 tecken per aktivitet") if @activity_errors
    errors.add(:language_list, "Max 48 tecken per språknamn") if @language_errors
  end

  after_create do
    # Map CMG ID when account is created
    update_attribute(:cmg_id, AastraCWI.get_cmg_id(self))
  end

  before_save do
    # Assign shortcuts to user the first time she selects a role in each category
    if !departments_setuped && roles.where(category: "department").present?
      add_shortcuts_from_roles("department")
      self.departments_setuped = true
    end

    if !working_fields_setuped && roles.where(category: "working_field").present?
      add_shortcuts_from_roles("working_field")
      self.working_fields_setuped = true
    end
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

  def reset_shortcuts_in_category(category)
    # Detach users shortcuts in given category
    shortcuts.where(category: category).each do |shortcut|
      shortcuts.delete(shortcut)
    end

    _shortcuts = shortcuts

    # Collect shortcuts from users roles in category
    roles.includes(:shortcuts).each do |role|
      _shortcuts += role.shortcuts.where(category: category)
    end

    self.shortcuts = _shortcuts.uniq
  end

  def add_shortcuts_from_roles(role_category)
    self.shortcuts = (shortcuts + roles.where(category: role_category).map { |r| r.shortcuts }.flatten).uniq
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

  # Activity names as tokens
  def activity_list
    activities.map(&:name).join(", ")
  end

  # Assign activity names from tokens
  def activity_list=(names)
    self.activities = names.split(",").map do |n|
      s = Activity.where(name: n.strip).first_or_create
      # Explicit validation for accociated model
      if s.valid?
        s
      else
        @activity_errors = true
        nil
      end
    end.compact
  end

  # Add activity by name
  def add_activity(name)
    self.activity_list = "#{activity_list}, #{name}"
  end

  # Get an array of the users feed_ids + feed_ids from the users roles
  # `category` is optional
  def combined_feed_ids(category = nil)
    if category.present?
      user_selected = feeds.where(category: category).pluck(:id)
      through_roles = roles.where('feeds.category' => category).includes(:feeds).select('feeds.id')
    else
      user_selected = feeds.pluck(:id)
      through_roles = roles.references(:feeds).includes(:feeds).select('feeds.id')
    end
    (user_selected + through_roles.map {|r| r.feeds.map(&:id) }).flatten.uniq
  end

  def self.tags(query, limit = 50, offset = 0)
    users = User.all

    # Match users tags
    %w(company department adm_department house_identifier physical_delivery_office_name title).each do |tag|
      next if query[tag.to_sym].blank?
      users = users.where(tag.to_sym => query[tag.to_sym])
    end

    # Match user's associated tags
    %w(skill activity language).each do |tag|
      next if query[tag.to_sym].blank?
      users = users.where("#{tag.pluralize.to_sym}.name" => query[tag.to_sym]).includes(tag.pluralize.to_sym)
    end

    { users: users.order(:first_name).limit(limit).offset(offset), total: users.count }
  end

  def self.search(query, limit = 25, offset = 0)
    return {} if query.empty?
    users = User.all
    q = "#{query[:q]}%"

    users = users.where("username LIKE ? OR first_name LIKE ? OR last_name LIKE ? OR
        concat_ws(' ', first_name, last_name) LIKE ? OR email LIKE ?", q, q, q, q, q)

    { users: users.order(:first_name).limit(limit).offset(offset), total: users.count }
  end

  private
    # Validate avatar before scaling it
    def validate_avatar_file_size
      valid? && errors.messages.blank?
    end
end
