require_relative 'feed_worker_utils'

def init_scope(args)
  [args[:scope],  FeedWorkerUtils.new(args[:scope])]
end

namespace :feed_worker do
  desc "Start feed runner"
  task :start, [:scope] => :environment do |t, args|
    scope, utils = init_scope(args)

    utils.start_runner
    while(utils.running?) do
      FeedWorker.update(scope)
      sleep 5
    end
  end

  desc "Stop feed runner"
  task :stop, [:scope] => :environment do |t, args|
    FeedWorkerUtils.new(args[:scope]).stop_runner
  end

  desc "Restart feed runner"
  task :restart, [:scope] => :environment do |t, args|
    Rake::Task["feed_worker:stop"].invoke(args[:scope])
    Rake::Task["feed_worker:start"].invoke(args[:scope])
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
