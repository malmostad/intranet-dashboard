class FeedWorker
  # Called by a background job to update feeds
  # Most of the code are conditionals for counters for statistics
  def self.update(feeds, options = {})
    started_at = Time.now.to_f
    failed = succeeded = not_modified = penalized = 0

    # feeds = Feed.where(category: ["news", "feature", "maintenance_warnings"])

    # Process feeds in shuffled order in smaller chunks
    feeds.shuffle.each do |feed|
      succeded_feeds = []
      failed_feeds = []
      # Penalty: Skip fetching of the feed in this round if it has enough of bad reputation
      if feed.recent_failures**2 > feed.recent_skips
        feed.update_attribute("recent_skips", feed.recent_skips + 1)
        penalized += 1
        next
      end

      feed.fetch_and_parse
      if feed.parsed_feed === 304
        not_modified += 1
      elsif feed.parsed_feed.is_a?(Integer) || feed.parsed_feed.blank?
        failed_feeds << feed
      else
        succeded_feeds << feed
      end

      # Save the chunk of fetched feeds
      succeded_feeds.each do |succeded_feed|
        succeeded += 1
        succeded_feed.map_feed_attributes
        succeded_feed.save(validate: false)
      end

      # Save stats for failed feeds
      failed_feeds.each do |failed_feed|
        failed += 1
        failed_feed.recent_failures += 1
        failed_feed.total_failures += 1
        failed_feed.save(validate: false)
      end
      sleep options[:feed_pause] || 10
    end

    # Log stats
    Rails.logger.info "FeedWorker updated feeds in #{(Time.now.to_f - started_at).ceil} seconds."
    Rails.logger.info "  Updated:      #{succeeded}"
    Rails.logger.info "  Not modified: #{not_modified}"
    Rails.logger.info "  Failed:       #{failed}"
    Rails.logger.info "  Penalized:    #{penalized}"
    Rails.logger.info "  Total:        #{succeeded + not_modified + failed + penalized}"
  end
end
