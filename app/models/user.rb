# -*- coding: utf-8 -*-
class User < ActiveRecord::Base

  has_and_belongs_to_many :roles
  has_and_belongs_to_many :feeds
  has_and_belongs_to_many :shortcuts
  has_many :user_agents, dependent: :destroy

  has_many :subordinates, class_name: "User", foreign_key: "manager_id"
  belongs_to :manager, class_name: "User"

  has_many :colleagueships, dependent: :destroy
  has_many :colleagues, through: :colleagueships
  has_many :inverse_colleagueships, class_name: "Colleagueship", foreign_key: "colleague_id", dependent: :destroy
  has_many :inverse_colleagues, through: :inverse_colleagueships, source: :user

  attr_accessible :phone, :cell_phone, :professional_bio, :status_message, :avatar, :role_ids, :feed_ids, :feeds, :shortcut_ids, :shortcuts
  attr_accessible :phone, :cell_phone, :professional_bio, :status_message, :avatar, :role_ids, :admin, as: :admin
  attr_accessor :avatar
  attr_reader :avatar_remote_url

  before_validation do
    self.status_message = status_message.slice(0, 70) if status_message.present?
  end

  validates_uniqueness_of :username
  validates :username, presence: { allow_blank: false }

  # Paperclip image, options is in the Paperclip initializer
  has_attached_file :avatar
  before_post_process :validate_avatar_file_size

  validates_attachment_content_type :avatar,
    content_type: ['image/tiff', 'image/jpeg', 'image/pjpeg', 'image/jp2'],
    message: "Fel bildformat. Du kan ladda upp en jpeg- eller tiff-bild"

  validates_attachment_size :avatar,
    less_than: 4.megabyte,
    message: "Bilden får inte vara större än 4MB."

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
    colleagueships.includes(:colleague).sort do |a,b|
      ( b.colleague.status_message_updated_at && a.colleague.status_message_updated_at ) ?
      b.colleague.status_message_updated_at <=> a.colleague.status_message_updated_at : ( a.colleague.status_message_updated_at ? -1 : 1 )
    end
  end

  # Search for users
  def self.search(term, limit = 20)
    where(
        "username LIKE ? OR
        first_name LIKE ? OR
        last_name LIKE ? OR
        concat_ws(' ', first_name, last_name) LIKE ? OR
        email LIKE ?",
      term, term, term, term, term)
    .order(:first_name).limit(limit)
  end

  private

  # Validate avatar before scaling it
  def validate_avatar_file_size
    valid?
    errors.messages.blank?
  end
end
