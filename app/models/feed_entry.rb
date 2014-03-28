require 'digest/sha1'

# Feedzirra entries
class FeedEntry < ActiveRecord::Base
  belongs_to :feed

  attr_accessor :pubDate

  # Define additional feed entry elements
  [ [ "wfw:commentRss", as: "comment_rss" ],
    [ "slash:comments", as: "count_comments" ],
    [ "comments",       as: "comments_link" ],
    [ "enclosure",      as: "image_url", value: "url" ],
    [ "enclosure",      as: "url_medium", value: "dashboard:url-medium" ],
    [ "enclosure",      as: "url_large", value: "dashboard:url-large" ],
    [ "published",      as: "pubDate" ],
    [ "guid",           as: "entry_id" ] # Feedzirra::Parser::ITunesRSSItem is using guid instead of entry_id
  ].each do |element|
    Feedzirra::Feed.add_common_feed_entry_element( element[0], element[1] )
  end

  before_save do
    # Don't save urls for non-ssl media if not allowed in config
    if !APP_CONFIG["allow_non_ssl_media"] && full.image_url.match(%q(^http://))
      self.full.image_url = nil
      self.full.url_medium = nil
      self.full.url_large = nil
    end
  end

  # Create or update feed entries for the feed
  def self.add_entries(feed_id, entries)
    entries.each do |entry|
      entry.published ||= entry.pubDate unless entry.pubDate.blank?
      entry.entry_id  ||= entry.url unless entry.url.blank?

      begin
        # Create a new feed entry or update existing
        e = where(guid: entry.entry_id, feed_id: feed_id).first_or_initialize
        e.feed_id = feed_id
        e.full = entry
        e.published_at = entry.published

        e.save
      rescue => e
        logger.error "Couldn't add feed entry #{e}"
      end
    end
  end
end
