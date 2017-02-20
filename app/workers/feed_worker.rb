class FeedWorker
  # Used for a background job to update feeds
  # Most of the code are conditionals for statistics logging
  def self.update(feeds = Feed.all, options = {})
    worker_logger = Logger.new(File.join(Rails.root, 'log', 'feed_worker.log'))
    worker_logger.level = Rails.logger.level

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

        # Do the job. HTTP response code is set in feed.response_status
        fetch_and_parsed = feed.fetch_and_parse(worker_logger)

        # Treat everything except 2xx and 3xx as an error
        if !fetch_and_parsed || !(feed.response_status.to_s =~ /^[23]/)
          failed += 1
          feed.update_attribute(:recent_failures, feed.recent_failures + 1)
          feed.update_attribute(:total_failures, feed.total_failures + 1)

        # The feed hasn't changed since fetch
        elsif feed.response_status == 304
          not_modified += 1

        # The feed has changed since fetch
        elsif feed.response_status == 200
          succeeded += 1
          feed.map_feed_attributes
          feed.feed_entries << feed.fresh_feed_entries
          feed.save(validate: false)
          feed.delete_stale_feed_entries
        end
      rescue => e
        worker_logger.error "#{e}. Feed id: #{feed.id}, #{feed.feed_url}"
        worker_logger.debug e.backtrace.join("\n")
      end

      # Take a rest before the next feed is fetched
      sleep options[:feed_pause] || 1
    end

    # Log stats
    worker_logger.info "FeedWorker updated feeds in #{(Time.now.to_f - started_at).ceil} seconds."
    worker_logger.info "  Updated:      #{succeeded}"
    worker_logger.info "  Not modified: #{not_modified}"
    worker_logger.info "  Failed:       #{failed}"
    worker_logger.info "  Penalized:    #{penalized}"
    worker_logger.info "  Total:        #{succeeded + not_modified + failed + penalized}"
  end
end
