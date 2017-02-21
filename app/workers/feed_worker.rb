class FeedWorker
  # Used for a background job to update feeds
  # Most of the code are conditionals for statistics logging
  def self.update(scope = 'main_feeds', options = {})
    worker_logger = Logger.new(File.join(Rails.root, 'log', "feed_worker_#{scope}.log"))
    worker_logger.level = Rails.logger.level

    if options[:feed_pause].present?
      feed_pause = options[:feed_pause]
    else
      feed_conf = APP_CONFIG['feed_worker']
      feed_pause = scope == 'main_feeds' ? feed_conf['main_feeds_pause'] : feed_conf['user_feeds_pause']
    end

    started_at = Time.now.to_f
    failed = succeeded = not_modified = penalized = 0

    feeds = Feed.public_send(scope)

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
        fetched_and_parsed = feed.fetch_and_parse(worker_logger)

        puts "fetched_and_parsed: #{fetched_and_parsed}"
        puts "feed.response_status: #{feed.response_status}"
        puts feed.response_status.class
        puts (feed.response_status.to_s =~ /^[23]/).class

        # The feed hasn't changed since fetch
        if feed.response_status == 304
          not_modified += 1

        # The feed was parsed and has changed since last fetch
        elsif fetched_and_parsed && feed.response_status == 200
          succeeded += 1
          feed.map_feed_attributes
          feed.feed_entries << feed.fresh_feed_entries
          feed.save(validate: false)
          feed.delete_stale_feed_entries

        # The feed failed fetching or parsing
        else
          failed += 1
          feed.update_attribute(:recent_failures, feed.recent_failures + 1)
          feed.update_attribute(:total_failures, feed.total_failures + 1)
        end
      rescue => e
        worker_logger.error "#{e}. Feed id: #{feed.id}, #{feed.feed_url}"
        worker_logger.debug e.backtrace.join("\n")
      end

      # Take a rest before the next feed is fetched
      sleep feed_pause
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
