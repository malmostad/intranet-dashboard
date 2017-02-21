require_relative 'feed_worker_utils'

def init_scope(args)
  [args[:scope],  FeedWorkerUtils.new(args[:scope])]
end

namespace :feed_worker do
  desc "Start feed runner"
  task :start, [:scope] => :environment do |t, args|
    scope, utils = init_scope(args)

    if scope == 'main'
      feeds = Feed.where.not(category: 'my_own')
      feed_pause = 1
    elsif scope == 'users'
      feeds = Feed.where(category: 'my_own')
      feed_pause = 5
    end

    utils.start_runner
    while(utils.running?) do
      FeedWorker.update(feeds, feed_pause: feed_pause)
      sleep 5
    end
  end

  desc "Stop feed runner"
  task :stop, [:scope] => :environment do |t, args|
    FeedWorkerUtils.new(args[:scope]).stop_runner
  end

  desc "Restart feed runner"
  task :restart, [:scope] => :environment do |t, args|
    Rake::Task["feed_worker:stop[#{args[:scope]}]"].invoke
    Rake::Task["feed_worker:start[#{args[:scope]}]"].invoke
  end

  desc "Show status for the feed runner"
  task :status, [:scope] => :environment do |t, args|
    scope, utils = init_scope(args)

    if utils.running?
      puts "Feed runner '#{scope}' is running with pid #{utils.pid}"
    else
      puts "Feed runner '#{scope}' is not running"
    end
  end
end
