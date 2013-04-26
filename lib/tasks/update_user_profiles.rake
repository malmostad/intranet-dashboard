desc "Update all user profiles from LDAP"
task update_user_profiles: :environment do
  started_at = Time.now.to_f
  deactivated = changed = 0

  ldap_client = Ldap.new
  User.find_each do |user|
  # User.all[0..100].each do |user|
    results = ldap_client.update_user_profile(user.username)
    if results
      changed += 1 if results[:changed]
    else
      deactivated += 1
    end
  end

  # Log stats
  puts "#{Time.now} update_user_profiles in #{(Time.now.to_f - started_at).ceil} seconds."
  puts "    Deactivated: #{deactivated}"
  puts "    Updated: #{changed}"
  puts "    Total: #{User.count}"
end
