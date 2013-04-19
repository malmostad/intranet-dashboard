# Whenever cron manager http://github.com/javan/whenever

# Installed w/capistrano: deploy.rb

# Check output with
# $ bundle exec whenever --set 'environment=production'

set :output,  "#{path}/log/cron.log"
set :real_environment, environment == "staging" ? "test" : "production" # 'staging' is a pseudo environment
job_type :rake, "cd :path && PATH=/usr/local/bin:$PATH RAILS_ENV=:real_environment bundle exec rake :task --silent :output"

if environment == "staging"
  every :day, :at => '2:13am' do
    rake "delete_old_feed_entries"
  end

  every :day, :at => '2:43am' do
    rake "clear_expired_sessions"
  end
end

if environment == "production"
  every :day, :at => '4:13am' do
    rake "delete_old_feed_entries"
  end

  every :day, :at => '4:43am' do
    rake "clear_expired_sessions"
  end
end

every :reboot do
  command "RAILS_ENV=#{real_environment} #{path}/lib/daemons/feed_worker_ctl start"
end