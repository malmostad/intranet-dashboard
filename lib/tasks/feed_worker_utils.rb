class FeedWorkerUtils
  def initialize(scope)
    @scope = scope
  end

  def start_runner
    if pid_file_exists?
      stop_runner
    end

    Process.daemon(true, true)
    File.open(pid_file, 'w') { |f| f << Process.pid }

    Signal.trap('TERM') { exit }

    Rails.logger.info "Starting task '#{@scope}' with pid #{Process.pid}"
    Process.pid
  end

  def stop_runner
    if pid_file_exists?
      if process_exists?
        Process.kill(9, pid)
        Rails.logger.info "Stopped task '#{@scope}' with pid #{pid}"
      else
        Rails.logger.warn "No task '#{@scope}' with pid #{pid} is running. Deleting pid file #{pid_file}"
      end
      File.delete pid_file
    else
      Rails.logger.warn "Pid file #{pid_file} does not exists"
    end
  end

  def running?
    pid_file_exists? && process_exists?
  end

  def pid_file_exists?
    File.exists? pid_file
  end

  def pid_file
    File.join(Rails.root, 'tmp', 'pids', "feed_worker_#{@scope}.pid")
  end

  def pid
    File.open(pid_file, "r") do |f|
      f.readline.to_i
    end
  end

  def process_exists?
    begin
      Process.kill 0, pid
      true
    rescue Errno::ESRCH
      false
    end
  end
end
