class Feed < ActiveRecord::Base
  attr_accessible :title, :feed_url, :category, :role_ids
  attr_reader :response_status

  CATEGORIES = {
    'news' => 'nyheter',
    'dialog' => 'diskussioner',
    'feature' => 'tema',
    'maintenance_warnings' => 'driftsmeddelanden',
    'my_own' => 'användare'
  }.freeze

  has_and_belongs_to_many :roles
  has_and_belongs_to_many :users
  has_many :feed_entries, dependent: :destroy

  # Feeds belonging to users
  scope :user_feeds, -> { where(category: 'my_own') }

  # Administrated feeds
  scope :main_feeds, -> { where.not(category: 'my_own') }

  # Auto-initiate the feed fetch and parsing process on create and update
  #   to get appropriate validation messages
  before_validation do
    if fetch_and_parse
      map_feed_attributes
      self.feed_entries << fresh_feed_entries
    end
  end

  # Fetch and parse a feed
  # Returns boolean
  def fetch_and_parse(other_logger = false)
    if other_logger
      Rails.logger = other_logger
    end

    fix_url
    response = fetch
    return false unless response
    parse(response)
  end

  # Parse the fetched feed file
  # Returns boolean and adds valdition errors
  def parse(xml)
    begin
      @parsed_feed = Feedjira::Feed.parse(xml)
      true
    rescue => e
      errors.add(:feed_url, "Flödet kunde inte tolkas. Kontrollera att det är ett giltigt RSS- eller Atom-flöde.")
      Rails.logger.info "Feedjira: #{e}. Feed id: #{id}, #{feed_url}"
      Rails.logger.debug e.backtrace.join("\n")
      false
    end
  end

  # Create or update feed entries for the feed
  def fresh_feed_entries
    return [] if @parsed_feed.blank?
    @_fresh_feed_entries ||=
      @parsed_feed.entries.map do |parsed_entry|
        # Don't store enties that are more than max_age old, or is missing a published date
        next if parsed_entry.published.blank? || parsed_entry.published < APP_CONFIG['feed_worker']['max_age'].days.ago

        entry = FeedEntry.where(guid: parsed_entry.entry_id, feed_id: id).first_or_initialize
        entry.published      = parsed_entry.published
        entry.url            = parsed_entry.url
        entry.title          = parsed_entry.title.present? ? parsed_entry.title[0...191] : 'Utan titel'
        entry.summary        = parsed_entry.summary
        entry.count_comments = parsed_entry.count_comments
        entry.image          = parsed_entry.image
        entry.image_medium   = parsed_entry.image_medium
        entry.image_large    = parsed_entry.image_large
        entry
      end.compact
  end

  def map_feed_attributes
    self.title            = @parsed_feed.title.present? ? @parsed_feed.title[0...191] : 'Utan titel'
    self.url              = @parsed_feed.url
    self.fetched_at       = Time.now
    self.recent_skips     = 0
    self.recent_failures  = 0
  end

  # Remove feed entries from the feed when not qualified, either:
  #   * isn't in the feed file anymore
  #   * is older than max_age
  def delete_stale_feed_entries
    begin
      if APP_CONFIG['feed_worker']['purge_stale_entries']
        FeedEntry.where(feed_id: id).where.not(id: fresh_feed_entries.map(&:id)).delete_all
      end
    rescue => e
      Rails.logger.info "Failed to delete_stale_feed_entries: #{e}. Feed id: #{id}, #{feed_url}"
      Rails.logger.debug e.backtrace.join("\n")
    end
  end

  # Delete feed entries for a feed. Fetch, parse and reset HTTP metadata
  def refresh_entries
    feed_entries.delete_all
    self.etag = nil
    self.last_modified = nil
    self.save
  end

  private
    # The HTTP fetching part for feeds.
    # Use Faraday directelty to handle HTTP caching, timeout and redirection
    #
    # Adds a validation error if fetching goes wrong
    #
    # Returns the feed as a string or false if it wasn't changed or if something failed
    # The HTTP response code is set in @response_status
    def fetch
      err_msg = 'Flödet kunde inte hämtas. Kontrollera att adressen är korrekt.'
      fetch_all = APP_CONFIG['feed_worker']['fetch_not_modified']
      begin
        faraday = Faraday.new do |connection|
          connection.use FaradayMiddleware::FollowRedirects, limit: 5
          connection.adapter :net_http
          connection.options[:timeout] = 10
          connection.ssl[:verify] = false
          # Set if_modified_since header only if we have a stored date
          #   and fetch_not_modified in config is set to false
          if last_modified.present? && !fetch_all
            connection.headers[:if_modified_since] = last_modified.httpdate
          end
        end
        response = faraday.get(URI.encode(feed_url))
        @response_status = response.status

        if response.body.present? && response.status == 200
          self.last_modified = response.env.response_headers[:last_modified]
          self.etag = response.env.response_headers[:etag]
          return response.body
        elsif !(response.status.to_s =~ /^[23]/)
          errors.add(:feed_url, err_msg)
          Rails.logger.info "Faraday response.status: #{response.status}"
          return false
        else
          return false
        end
      rescue => e
        errors.add(:feed_url, err_msg)
        Rails.logger.info "Faraday: #{e}. Feed id: #{id}, #{feed_url}"
        Rails.logger.debug e.backtrace.join("\n")
        false
      end
    end

    # Pre-parsing and fixing of a feed url, manipulate it for some special cases
    def fix_url
      # Remove Safari’s pseudo protocol
      self.feed_url.gsub!(/^feed:\/\//, '')

      # Convert #<hashtag(s)> to a twitter search feed for given hash tag(s)
      if feed_url.match(/^#/)
        self.feed_url = "http://search.twitter.com/search.rss?q=#{URI.escape(feed_url)}"

      # Convert @user to a twitter search feed for that user
      elsif feed_url.match(/^@/)
        feed_url.gsub!(/@/, '')
        self.feed_url = "http://twitter.com/statuses/user_timeline/#{URI.escape(feed_url)}.rss"

      # Convert shortnames to a Komin blog feed
      elsif feed_url.present? && !feed_url.match(/[\.\/]/)
        self.feed_url = "http://kominblogg.malmo.se/author/#{URI.escape(feed_url)}/feed/"

      # Add http:// if not there. Allow file:// for specs
      else
        self.feed_url = "http://#{feed_url}" unless feed_url.match(/^(https?|file):\/\//)
      end
    end
end
