namespace :users do
  desc "Update all user profiles from LDAP"
  task update_profiles: :environment do
    started_at = Time.now.to_f
    deleted = deactivated = updated = 0
    address_diff = []

    User.unscoped.find_each do |user|
      begin
        ldap = Ldap.new
        if ldap.update_user_profile(user)
          # Diff between LDAP and Dashboard address
          if ldap.address[:dashboard] != ldap.address[:ldap] && !user.deactivated
            address_diff << [user.displayname, user.username, ldap.address[:dashboard], ldap.address[:ldap]]
          end
          updated += 1 if ldap.user_profile_changed
        else
          # User is deactivated in the LDAP
          if user.deactivated? && user.deactivated_at < 45.days.ago
            # Delete the user if it has been deactivated in the Dashboard for 45 days
            user.destroy
            deleted += 1
          elsif !user.deactivated?
            # Mark the user as deactivated
            user.deactivated = true
            user.deactivated_at = DateTime.now
            user.user_agents.destroy_all
            user.save(validate: false)
            deactivated += 1
          end
        end
      rescue => e
        puts "Error updating user #{user.id}"
        puts "Error: #{e}"
      end
    end

    # Log users with diffs between the address in ldap and dashboard in an xlsx file
    axlsx = Axlsx::Package.new
    heading = axlsx.workbook.styles.add_style font_name: 'Calibri', bg_color: "000000", fg_color: "FFFFFF"
    body = axlsx.workbook.styles.add_style font_name: 'Calibri', fg_color: "000000"
    axlsx.workbook.add_worksheet(name: "KB-Intra diff") do |sheet|
      sheet.add_row ["Namn", "Katalognamn", "Adress i kontaktboken", "Adress i Intra", "Kontaktkort"], style: heading
      address_diff.each do |diff|
        diff << "https://minsida.malmo.se/users/#{diff[1]}"
        sheet.add_row diff, style: body
      end
      sheet.add_row ["Rapport genererad #{Time.now.localtime.to_s[0..18]}"], style: body
    end
    axlsx.serialize(APP_CONFIG["ldap"]["diff_log"])

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
    puts "#{Time.now} Expired sessions removed in #{(Time.new.to_f - t)} seconds"
  end
end
