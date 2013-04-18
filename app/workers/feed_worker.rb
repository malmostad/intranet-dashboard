class FeedWorker
  # Called by a background job to update all feeds
  # Most of the code are conditionals for counters for statistics
  def self.update_all
    started_at = Time.now.to_f
    failed = succeeded = updated = skipped = 0

    # Process feeds in shuffled order in smaller chunks
    Feed.all.shuffle.each_slice(APP_CONFIG['feed_worker_concurrency']) do |feeds|
      threads = []
      fetched_feeds = []
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
          if feed.fetch
            fetched_feeds << feed
          else
            failed_feeds << feed
          end
        end
      end
      threads.each {|t| t.join }

      # Parse and save the chunk of fetched feed
      fetched_feeds.each do |fetched_feed|
        if fetched_feed.parse
          succeeded += 1
          if fetched_feed.updated
            updated += 1
          elsif fetched_feed.recent_failures == 0 # Save only if prev fetch failed
            next
          end
          fetched_feed.recent_failures = 0
          fetched_feed.save(validate: false)
        else
          failed_feeds << fetched_feed
        end
      end

      # Save stats for failed feed
      failed_feeds.each do |failed_feed|
        failed += 1
        failed_feed.recent_failures += 1
        failed_feed.total_failures += 1
        failed_feed.save(validate: false)
      end
      sleep APP_CONFIG['feed_worker_batch_pause']
    end

    # Log stats
    Rails.logger.warn "    FeedWorker updated feeds in #{(Time.now.to_f - started_at).ceil} seconds."
    Rails.logger.warn "    Succeeded: #{succeeded}"
    Rails.logger.warn "    Failed: #{failed}"
    Rails.logger.warn "    Skipped: #{skipped}"
    Rails.logger.warn "    Updated: #{updated}"
    Rails.logger.warn "    Total: #{failed + succeeded + skipped}"

    sleep APP_CONFIG['feed_worker_cycle_pause']
  end
end
