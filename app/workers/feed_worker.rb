class FeedWorker
  # Called by a background job to update all feeds
  # Most of the code are conditionals for counters for statistics
  def self.update_all
    started_at = Time.now.to_f
    failed = succeeded = not_modified = penalized = 0

    # Process feeds in shuffled order in smaller chunks
    Feed.all.shuffle.each_slice(APP_CONFIG['feed_worker_concurrency']) do |feeds|
      threads = []
      succeded_feeds = []
      failed_feeds = []
      feeds.each do |feed|
        # Penalty: Skip fetching of the feed in this round if it has enough of bad reputation
        if feed.recent_failures**2 > feed.recent_skips
          feed.update_attribute("recent_skips", feed.recent_skips + 1)
          penalized += 1
          next
        end

        # Threaded fetching of the feeds
        threads << Thread.new do
          feed.fetch_and_parse
          if feed.parsed_feed === 304
            not_modified += 1
          elsif feed.parsed_feed.is_a?(Fixnum) || feed.parsed_feed.blank?
            failed_feeds << feed
          else
            succeded_feeds << feed
          end
        end
      end
      threads.each {|t| t.join }

      # Save the chunk of fetched feeds
      succeded_feeds.each do |feed|
        succeeded += 1
        feed.map_feed_attributes
        feed.save(validate: false)
      end

      # Save stats for failed feeds
      failed_feeds.each do |feed|
        failed += 1
        feed.recent_failures += 1
        feed.total_failures += 1
        feed.save(validate: false)
      end
      sleep APP_CONFIG['feed_worker_batch_pause']
    end

    # Log stats
    Rails.logger.warn "    FeedWorker updated feeds in #{(Time.now.to_f - started_at).ceil} seconds."
    Rails.logger.warn "    Updated: #{succeeded}"
    Rails.logger.warn "    Not modified: #{not_modified}"
    Rails.logger.warn "    Failed: #{failed}"
    Rails.logger.warn "    Penalized: #{penalized}"
    Rails.logger.warn "    Total: #{succeeded + not_modified + failed + penalized}"

    sleep APP_CONFIG['feed_worker_cycle_pause']
  end
end
