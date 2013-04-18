# -*- coding: utf-8 -*-

# Point /etc/init.d/dashboard-god to this file

# Use it standalone like:
# $ sudo god -c config/daemons.god
# $ sudo god status
# $ sudo god stop feed_daemon
# $ sudo god terminate

def monitor(w, app_root, options = {})
  script = "#{app_root}/lib/daemons/feed_daemon_ctl"
  w.interval = 10.seconds
  w.start = "#{script} start"
  w.restart = "#{script} restart"
  w.stop = "#{script} stop"
  w.stop_grace = 240.seconds
  w.start_grace = 120.seconds
  w.restart_grace = 60.seconds
  w.pid_file = "#{app_root}/log/feed_daemon.pid"
  w.log = "#{app_root}/log/god.log"

  w.behavior(:clean_pid_file)

  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 10.seconds
      c.running = false
    end
  end

  w.restart_if do |restart|
    restart.condition(:memory_usage) do |c|
      c.above = 200.megabytes
      c.times = [3, 5] # 3 out of 5 intervals
    end

    restart.condition(:cpu_usage) do |c|
      c.above = 50.percent
      c.times = 5
    end
  end

  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minute
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
    end
  end

  # w.transition(:up, :start) do |on|
  #   on.condition(:process_exits) do |c|
  #     c.notify = 'developers'
  #   end
  # end
end

#require 'tlsmail'
# God::Contacts::Email.defaults do |d|
#   Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
#   d.server_host     = 'smtp.example.org'
#   d.from_email      = "noreply@example.org"
#   d.from_name       = "Dashboard monitoring"
#   d.delivery_method = :smtp
# end

# God.contact(:email) do |c|
#   c.name     = "Dev Guy"
#   c.group    = "developers"
#   c.to_email = "dev.guy@example.org"
#   c.to_name  = "Dev Guy"
# end


# God.watch do |w|
#   w.name = "feed_daemon"
#   w.env = { 'RAILS_ENV' => "production" }
#   app_root = "/var/www/dashboard/production/current"
#   monitor(w, app_root)
# end

God.watch do |w|
  w.name = "feed_daemon_test"
  w.env = { 'RAILS_ENV' => "test" }
  app_root = "/var/www/dashboard/test/current"
  monitor(w, app_root)
end