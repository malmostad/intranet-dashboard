# -*- coding: utf-8 -*-
namespace :users do
  desc "Update all user profiles from LDAP"
  task update_profiles: :environment do
    started_at = Time.now.to_f
    deleted = deactivated = updated = 0

    # Log user with diffs between the address in ldap and dashboard
    address_diff_file = File.new(APP_CONFIG["ldap"]["diff_log"], "w")
    address_diff_file.puts "Diff startad #{Time.now.localtime.to_s[0..18]}"
    address_diff_file.puts "Namn\tKatalognamn\tAdress i kontaktboken\tAdress i ADM"

    User.unscoped.find_each do |user|
      begin
        ldap = Ldap.new
        results = ldap.update_user_profile(user.username)
        if results
          if ldap.address[:dashboard] != ldap.address[:ldap] && !user.deactivated
            address_diff_file.puts %q(#{user.displayname}\t#{user.username}\t#"{ldap.address[:dashboard]}"\t"#{ldap.address[:ldap]}")
          end

          updated += 1 if ldap.user_profile_changed
        else
          # User is deactivated in the LDAP
          if user.deactivated? && user.deactivated_at > Time.now + 45.days
            # Delete the user if it has been deactivated in the Dashboard for 45 days
            user.destroy
          elsif !user.deactivated?
            # Mark the user as deactivated
            user.deactivated = true
            user.deactivated_at = DateTime.now
            user.save(validate: false)
            deactivated += 1
          end
        end
      rescue Exception => e
        puts "Error updating user #{user.id}"
        puts "Exception: #{e}"
      end
    end

    address_diff_file.puts "Diff slutförd #{Time.now.localtime.to_s[0..18]}"
    address_diff_file.close

    # Log stats
    puts "#{Time.now} update_user_profiles in #{(Time.now.to_f - started_at).ceil} seconds."
    puts "  Deleted: #{deleted}"
    puts "  Deactivated: #{deactivated}"
    puts "  Updated: #{updated}"
    puts "  Total: #{User.count}"
  end

  desc "Map CMG ID for users"
  task map_cmg_ids: :environment do
    started_at = Time.now.to_f
    mapped = 0

    User.find_each do |user|
      cmg_id = AastraCWI.get_cmg_id(user)
      if cmg_id
        mapped += 1
        user.update_attribute(:cmg_id, cmg_id)
      end
    end
    puts "#{Time.now} update_user_profiles in #{(Time.now.to_f - started_at).ceil} seconds."
    puts "    Mapped: #{mapped}"
    puts "    Total: #{User.count}"
  end

  desc "Clear expired sessions and optimize the table"
  task clear_expired_sessions: :environment do
    t = Time.new.to_f
    ActiveRecord::Base.connection.execute('DELETE FROM sessions WHERE updated_at < DATE_SUB(NOW(), INTERVAL 12 HOUR);')
    # ActiveRecord::Base.connection.execute('OPTIMIZE TABLE sessions;')
    puts "#{Time.now} Expired sessions removed in #{(Time.new.to_f - t)} seconds"
  end
end
