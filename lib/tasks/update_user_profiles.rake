desc "Update all user profiles from LDAP"
task update_user_profiles: :environment do
  started_at = Time.now.to_f
  failed = deactivated = 0

  ldap_client = Ldap.new
  User.find_each do |user|
    begin
      results = ldap_client.update_user_profile(user.username)
      deactivated += 1 unless results
    rescue
      failed += 1
    end
  end

  # Log stats
  puts "#{Time.now} update_user_profiles rake task updated users in #{(Time.now.to_f - started_at).ceil} seconds."
  puts "    Deactivated: #{deactivated}"
  puts "    Failed: #{failed}"
  puts "    Total: #{User.count}"
end
