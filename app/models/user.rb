# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

  # Autocomplete for suggestion names or phone numbers
  # TODO: phone numbers are matching from the back, intentionally
  # so no suggetsion is made before at least the five last digits are entered
  #
  # POST /users/_search
  # {
  #    "size": 2000,
  #    "fields": [
  #       "displayname",
  #       "username",
  #       "company_short",
  #       "department"
  #    ],
  #    "query": {
  #       "bool": {
  #          "should": [
  #             {
  #                "match": {
  #                   "displayname_suggest": {
  #                      "query": "asdasdasdasdasdas",
  #                      "fuzziness": 0.8,
  #                      "prefix_length": 0
  #                   }
  #                }
  #             },
  #             {
  #                "multi_match": {
  #                   "fields": [
  #                      "phone",
  #                      "cell_phone"
  #                   ],
  #                   "query": "341029"
  #                }
  #             }
  #          ]
  #       }
  #    }
  # }





  # EdgeNgram start matching for autocompletion.
  # Matches "first last", "last first", "username" from start with fuzziness in percent or edition distance
  #
  # POST /users/_search
  # {
  #    "size": 2000,
  #    "fields": ["displayname", "username", "company_short", "department"],
  #    "query": {
  #       "match": {
  #          "displayname_suggest": {
  #             "query": "bylund jes",
  #             "fuzziness": 0.8,
  #             "prefix_length": 0
  #          }
  #       }
  #    }
  # }

  # Fast elastic suggest completion.
  # No scoring for exact matches.
  #
  # POST /users/_suggest
  # {
  #    "users_suggest" : {
  #     "text" : "carlsson",
  #     "completion" : {
  #       "size": 1000,
  #       "field" : "name_suggest",
  #         "fuzzy": {
  #             "edit_distance": 1,
  #             "prefix_length": 0,
  #             "unicode_aware": true
  #         }
  #     }
  #   }
  # }

  # Matches phone number from the end.
  # Ignores everything non-digit. Possible to match front-truncated 5 digit numbers
  #
  # POST /users/_search
  # {
  #    "size": 200,
  #    "query": {
  #       "multi_match": {
  #         "fields": ["phone", "cell_phone"],
  #         "query": "040-341029"
  #       }
  #    }
  # }

  # Query on selected fields. Swedish snowball filter
  #
  # POST /users/_search
  # {
  #     "query": {
  #         "query_string": {
  #             "query": "personalavin",
  #             "fields": ["skills", "professional_bio"]
  #         }
  #     }
  # }

  settings analysis: {
    analyzer: {
      swedish_ngram_2: {
        language: "Swedish",
        tokenizer: "ngram_2",
        filter: ["swedish_snowball"]
      },
      displayname_index: {
        tokenizer: "whitespace",
        filter: ["lowercase", "edge_start_2"],
        char_filter: ["letters_digits"]
      },
      displayname_search: {
        tokenizer: "keyword",
        filter: ["lowercase"],
        char_filter: ["name_suggest"]
      },
      swedish_snowball: {
        language: "Swedish",
        tokenizer: "standard",
        filter: ["swedish_snowball"]
      },
      phone_number: {
        tokenizer: "keyword",
        filter: ["phone_number"],
        char_filter: ["phone_number"]
      }
    },
    tokenizer: {
      ngram_2: {
        type: "nGram",
        min_gram: 2,
        max_gram: 10,
        token_chars: ["letter", "digit"]
      },
      comma: {
        type: "pattern",
        pattern: "\\s*,\\s*"
      }
    },
    filter: {
     swedish_snowball: {
       type: "snowball",
       language: "Swedish"
      },
      phone_number: {
        type: "edgeNGram",
        side: "back",
        min_gram: 5,
        max_gram: 12
      },
      edge_start_2: {
        type: "edgeNGram",
        min_gram: 2,
        max_gram: 50
      }
    },
    char_filter: {
      phone_number: {
        type: "pattern_replace",
        pattern: "[^0-9]",
        replacement: ""
      },
      letters_digits: {
        type: "pattern_replace",
        pattern: "[^\\w\\d]",
        replacement: " "
      },
      normalize_space: {
        type: "pattern_replace",
        pattern: "\\s+",
        replacement: " "
      },
      name_suggest: {
        type: "pattern_replace",
        pattern: "[^\\w\\d]",
        replacement: ""
      },
      phonetic_mappings: {
        type: "mapping",
        mappings: ["ph=>f", "c=>k", "sch" => "sk"]
      }
    }
  }

  mapping do
    indexes :id, index: 'not_analyzed'
    indexes :username, analyzer: 'simple'
    indexes :displayname, analyzer: 'simple'
    indexes :displayname_suggest, index_analyzer: 'displayname_index', search_analyzer: 'displayname_search'
    indexes :name_suggest, type: 'completion', analyzer: 'simple', payloads: true
    indexes :professional_bio, analyzer: 'swedish_snowball'
    indexes :professional_bio_2, analyzer: 'swedish_ngram_2'
    indexes :skills, analyzer: 'swedish_snowball'
    indexes :languages, analyzer: 'swedish_snowball'
    indexes :phone, analyzer: 'phone_number'
    indexes :cell_phone, analyzer: 'phone_number'
    indexes :company_short, analyzer: 'simple'
    indexes :department, analyzer: 'simple'
  end

  def to_indexed_json
    {
      id: id,
      username: username,
      displayname: displayname,
      displayname_suggest: "#{first_name}#{last_name} #{last_name}#{first_name} #{username}",
      name_suggest: {
        input: [first_name, last_name, "#{last_name} #{first_name}", displayname, username],
        output: displayname,
        weight: 34,
        payload: {
          username: username,
          company_short: company_short,
          department: department
        }
      },
      professional_bio: professional_bio,
      professional_bio_2: professional_bio,
      skills: skills.map { |m| m.name },
      languages: languages.map { |m| m.name },
      phone: phone,
      cell_phone: cell_phone,
      company_short: company_short,
      department: department
    }.to_json
  end

  after_touch do
    tire.update_index
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
