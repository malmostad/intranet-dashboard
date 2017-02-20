Rails.logger       = Logger.new(Rails.root.join('log', 'feed_runner.log'))
Rails.logger.level = 'info'

namespace :feed_runner do
  namespace :main do
    desc 'Start fetching feeds for the main categories'
    task start: :environment do
      pid = start_runner('main')

      while(running?('main', pid)) do
        feeds = Feed.where(category: ['maintenance_warnings', 'news', 'feature'])
        FeedRunner.update(feeds, { feed_pause: 0 })
        sleep 5
      end
    end

    desc 'Stop fetching feeds for the main categories'
    task stop: :environment do
      stop_runner('main')
    end
  end
end

def start_runner(task)
  if pid_file_exists_for? task
    stop_runner(task)
  end

  pid_file = pid_file_for(task)

  Process.daemon(true, true)
  File.open(pid_file, 'w') { |f| f << Process.pid }

  Signal.trap('TERM') { exit }

  Rails.logger.info "Starting feed runner #{task} with pid #{Process.pid}"
  Process.pid
end

def stop_runner(task)
  pid_file = pid_file_for(task)

  if pid_file_exists_for?(task)
    pid = pid_for(task)

    if process_exists? pid
      Process.kill(9, pid)
      Rails.logger.info "Stopped task #{task} with pid #{pid}"
    else
      Rails.logger.warn "No #{task} with pid #{pid} is running. Deleting pid file #{pid_file}"
    end
    File.delete pid_file
  else
    Rails.logger.warn "Pid file #{pid_file} does not exists"
  end
end

def running?(task, pid)
  File.exists?(pid_file_for(task)) && process_exists?(pid)
end

def pid_file_exists_for?(task)
  File.exists? pid_file_for(task)
end

def pid_file_for(task)
  File.join(Rails.root, 'tmp', 'pids', "feed_runner_#{task}.pid")
end

def pid_for(task)
  File.open(pid_file_for(task), "r") do |f|
    f.readline.to_i
  end
end

def process_exists?(pid)
  begin
    Process.kill(0, pid)
    true
  rescue Errno::ESRCH
    false
  end
end
