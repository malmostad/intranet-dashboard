desc "Update all user profiles from LDAP"
task update_user_profiles: :environment do
  started_at = Time.now.to_f
  deactivated = updated = 0

  User.find_each do |user|
  # User.all[0..100].each do |user|
    ldap = Ldap.new
    results = ldap.update_user_profile(user.username)
    if results
      updated += 1 if ldap.user_profile_changed
    else
      deactivated += 1
    end
  end

  # Log stats
  puts "#{Time.now} update_user_profiles in #{(Time.now.to_f - started_at).ceil} seconds."
  puts "    Deactivated: #{deactivated}"
  puts "    Updated: #{updated}"
  puts "    Total: #{User.count}"
end
