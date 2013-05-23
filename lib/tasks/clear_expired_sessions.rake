desc "Clear expired sessions and optimize the table"
task clear_expired_sessions: :environment do
  t = Time.new.to_f
  ActiveRecord::Base.connection.execute('DELETE FROM sessions WHERE updated_at < DATE_SUB(NOW(), INTERVAL 1 DAY);')
  # ActiveRecord::Base.connection.execute('OPTIMIZE TABLE sessions;')
  puts "#{Time.now} Expired sessions removed in #{(Time.new.to_f - t)} seconds"
end
