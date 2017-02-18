namespace :feeds do
  desc 'Delete old feed entries and optimize the table'
  task delete_old_entries: :environment do
    t = Time.new.to_f
    fe_before = FeedEntry.count
    FeedEntry.where('published < ?', APP_CONFIG['feed_worker']['max_age'].days.ago).delete_all
    fe_after = FeedEntry.count
    puts "#{Time.now} #{fe_before - fe_after} expired feed entries older than #{APP_CONFIG['feed_worker']['max_age']} days removed in #{(Time.new.to_f - t)} seconds"
  end
end
