namespace :feeds do
  desc 'Delete old feed entries and optimize the table'
  task delete_old_entries: :environment do
    t = Time.new.to_f
    fe_before = FeedEntry.count
    FeedEntry.where('published < ?', APP_CONFIG['feed_worker']['max_age'].days.ago).delete_all
    fe_after = FeedEntry.count
    puts "#{Time.now} #{fe_before - fe_after} expired feed entries older than #{APP_CONFIG['feed_worker']['max_age']} days removed in #{(Time.new.to_f - t)} seconds"
  end

  # Feeds added by users, (category "my_own"), is ment to be shared.
  # Since this functionality isn't exposed, delete user feeds with
  #   no owner, i.e. the user has been deleted
  desc 'Delete orphan user feeds,category "my_own". '
  task delete_orphans: :environment do
    f_before = Feed.count
    Feed.includes(:users).where(category: 'my_own', users: { id: nil }).destroy_all
    f_after = Feed.count
    puts "#{Time.now} #{f_before - f_after} orphan user feeds removed"
  end
end
