# -*- coding: utf-8 -*-
require 'open-uri'

# News feeds
class Feed < ActiveRecord::Base
  CATEGORIES = {
    "news" => "nyheter",
    "dialog" => "diskussioner",
    "feature" => "tema",
    "my_own" => "användare"
  }

  has_and_belongs_to_many :roles
  has_and_belongs_to_many :users
  has_many :feed_entries, dependent: :destroy

  attr_accessible :title, :feed_url, :category, :role_ids

  # Bind some data to the feed during fetching and parsing
  attr_accessor :content, :parsed_feed, :updated

  # Fetch url and parse it is part of the form validation.
  # Validation is disabled in workers batch mode
  before_validation :fix_url, :fetch, :parse
  after_save :save_feed_entries

  # Fetch a feed w/open-uri
  def fetch
    begin
      timeout(5) do
        self.content = open(feed_url).read
      end
      true
    rescue Exception => e
      errors.add(:feed_url, "Flödet kunde inte hämtas.")
      logger.info "Couldn't fetch feed #{id} #{feed_url}: #{e}"
      false
    end
  end

  # Parse a feed file w/Feedzirra
  def parse
    begin
      self.parsed_feed = Feedzirra::Feed.parse(content)
      self.title = parsed_feed.title || "Utan titel"
      self.url = parsed_feed.url
      self.fetched_at = Time.now
      previous_checksum = checksum
      self.checksum = Digest::MD5.hexdigest(content)

      # Is the feed updated since last fetch?
      self.updated = previous_checksum != checksum
      true
    rescue Exception => e
      # Parsing failed
      logger.info "Couldn't parse feed #{id} #{feed_url}: #{e}"
      errors.add(:feed_url, "Flödet kunde inte tolkas. Kontrollera att det är ett giltigt RSS- eller Atom-flöde.")
      false
    end
  end

  def refresh_entries
    feed_entries.delete_all
    # Force validation, fetch, parse and save feed entries
    self.fetched_at = nil
    self.checksum = nil
    self.save
  end

  private
    # Create or update feed entries for the feed
    def save_feed_entries
      if updated
        parsed_feed.entries.each do |parsed_entry|
          # We found some feeds without id (guids) in the entries, use url in those cases
          parsed_entry.id ||= parsed_entry.url unless parsed_entry.url.blank?
          parsed_entry.published ||= parsed_entry.updated unless parsed_entry.updated.blank?

          # Don't save urls for non-ssl media if not allowed in config
          if !APP_CONFIG["allow_non_ssl_media"] && parsed_entry.respond_to?(:image) &&
              parsed_entry.image.present? && parsed_entry.image.match(%q(^http://))
            parsed_entry.image = nil
            parsed_entry.image_medium = nil
            parsed_entry.image_large = nil
          end

          # Find or initialize new entry
          entry = FeedEntry.where(guid: parsed_entry.id, feed_id: id).first_or_initialize

          # Slice those attributes from fetched_feed that we have FeedENtry columns for
          entry.update_attributes parsed_entry.to_h.slice(*FeedEntry.column_names)
        end
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
        self.feed_url = "http://webapps04.malmo.se/blogg/author/#{URI.escape(feed_url)}/feed/"

      # Add http:// if not there
      else
        self.feed_url = "http://#{feed_url}" unless feed_url.match(/^https?:\/\//)
      end
    end
end
