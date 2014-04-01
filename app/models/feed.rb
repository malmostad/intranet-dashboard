# -*- coding: utf-8 -*-

# News feeds
class Feed < ActiveRecord::Base
  attr_accessible :title, :feed_url, :category, :role_ids
  attr_reader :parsed_feed

  CATEGORIES = {
    "news" => "nyheter",
    "dialog" => "diskussioner",
    "feature" => "tema",
    "my_own" => "användare"
  }

  has_and_belongs_to_many :roles
  has_and_belongs_to_many :users
  has_many :feed_entries, dependent: :destroy

  before_validation do
    # Fetch and parse feed, to get appropriate validation messages
    if fetch_and_parse
      map_feed_attributes
    end
  end

  def fetch_and_parse
    fix_url
    begin
      @parsed_feed = Feedjira::Feed.fetch_and_parse(feed_url, timeout: 5, compress: true)

      # Raise if we get HTTP error code or nil instead of feedjira object
      raise "Failed fetching" if @parsed_feed.is_a? Fixnum || @parsed_feed.blank?
      true
    rescue Exception => e
      errors.add(:feed_url, "Flödet kunde inte hämtas eller var ogiltigt. Kontrollera att det är ett giltigt RSS- eller Atom-flöde.")
      logger.info "Feedjira: #{e}. Feed id: #{id}, #{feed_url}"
      false
    end
  end

  # Create or update feed entries for the feed
  def fresh_feed_entries
    @parsed_feed.entries.map do |parsed_entry|
      entry = FeedEntry.where(guid: parsed_entry.entry_id, feed_id: id).first_or_initialize
      entry.published      = parsed_entry.published
      entry.url            = parsed_entry.url
      entry.title          = parsed_entry.title
      entry.summary        = parsed_entry.summary
      entry.count_comments = parsed_entry.count_comments
      entry.image          = parsed_entry.image
      entry.image_medium   = parsed_entry.image_medium
      entry.image_large    = parsed_entry.image_large
      entry
    end
  end

  def refresh_entries
    feed_entries.delete_all
    # Force validation, fetch, parse and save feed entries
    self.fetched_at = nil
    self.checksum = nil
    self.save
  end

  def map_feed_attributes
    self.title = @parsed_feed.title || "Utan titel"
    self.url = @parsed_feed.url
    self.fetched_at = Time.now
    self.feed_entries << fresh_feed_entries
  end

  private
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
        self.feed_url = "http://webapps04.malmo.se/blogg/author/#{URI.escape(feed_url)}/feed/"

      # Add http:// if not there. Allow file:// for specs
      else
        self.feed_url = "http://#{feed_url}" unless feed_url.match(/^(https?|file):\/\//)
      end
    end
end
