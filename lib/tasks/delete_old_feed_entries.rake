desc "Delete old feed entries and optimize the table"
task delete_old_feed_entries: :environment do
    t = Time.new.to_f
    fe_before = FeedEntry.count
    ActiveRecord::Base.connection.execute('DELETE FROM feed_entries WHERE published_at < DATE_SUB(NOW(), INTERVAL 4 WEEK);')
    # ActiveRecord::Base.connection.execute('OPTIMIZE TABLE feed_entries;')
    fe_after = FeedEntry.count
    puts "#{Time.now} #{fe_before - fe_after} expired feed entries removed in #{(Time.new.to_f - t)} seconds"
end
