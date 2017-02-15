class FeedWorker
  # Called by a background job to update feeds
  # Most of the code are conditionals for statistics logging
  def self.update(feeds = Feed.all, options = {})
    started_at = Time.now.to_f
    failed = succeeded = not_modified = penalized = 0

    # Process feeds in shuffled order
    feeds.shuffle.each do |feed|
      begin
        # Penalty: Skip fetching the feed in this round if it has enough of bad reputation
        if feed.recent_failures**2 > feed.recent_skips
          feed.update_attribute(:recent_skips, feed.recent_skips + 1)
          penalized += 1
          next
        end

        feed.fetch_and_parse

        if feed.parsed_feed === 304
          not_modified += 1
        elsif feed.parsed_feed.is_a?(Integer) || feed.parsed_feed.blank?
          failed += 1
          feed.update_attribute(:recent_failures, feed.recent_failures + 1)
          feed.update_attribute(:total_failures, feed.total_failures + 1)
        else
          succeeded += 1
          feed.map_feed_attributes
          feed.feed_entries << feed.fresh_feed_entries
          feed.map_feed_attributes
          feed.save(validate: false)
        end
      rescue Exception => e
        Rails.logger.error "#{e}. Feed id: #{feed.id}, #{feed.feed_url}. Backtrace:"
        Rails.logger.error e.backtrace.join("\n")
      end

      sleep options[:feed_pause] || 1
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
