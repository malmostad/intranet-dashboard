class FeedWorker
  # Called by a background job to update all feeds
  # Most of the code are conditionals for counters for statistics
  def self.update_all
    started_at = Time.now.to_f
    failed = succeeded  = skipped = 0

    # Process feeds in shuffled order in smaller chunks
    Feed.all.shuffle.each_slice(APP_CONFIG['feed_worker_concurrency']) do |feeds|
      threads = []
      succeded_feeds = []
      failed_feeds = []
      feeds.each do |feed|
        # Penalty: Skip fetching of the feed in this round if it has enough of bad reputation
        if feed.recent_failures**2 > feed.recent_skips
          feed.update_attribute("recent_skips", feed.recent_skips + 1)
          skipped += 1
          next
        end

        # Threaded fetching of the feeds
        threads << Thread.new do
          if feed.fetch_and_parse
            succeded_feeds << feed
          else
            failed_feeds << feed
          end
        end
      end
      threads.each {|t| t.join }

      # Save the chunk of fetched feeds
      succeded_feeds.each do |feed|
        succeeded += 1
        feed.recent_failures = 0
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
    Rails.logger.warn "    Succeeded: #{succeeded}"
    Rails.logger.warn "    Failed: #{failed}"
    Rails.logger.warn "    Skipped: #{skipped}"
    Rails.logger.warn "    Total: #{failed + succeeded + skipped}"

    sleep APP_CONFIG['feed_worker_cycle_pause']
  end
end
