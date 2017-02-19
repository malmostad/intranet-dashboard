# -*- coding: utf-8 -*-
class Ldap
  attr_reader :user_profile_changed, :address

  def initialize
    @client = Net::LDAP.new(
      host: APP_CONFIG["ldap"]["host"],
      port: APP_CONFIG["ldap"]["port"],
      encryption: { method: :simple_tls },
      auth: {
        method: :simple,
        username: APP_CONFIG['ldap']['proxy_user'],
        password: APP_CONFIG['ldap']['proxy_password']
      }
    )
  end

  def authenticate(username, password)
    return false if username.empty? || password.empty?

    bind_user = @client.bind_as(base: APP_CONFIG["ldap"]["base_dn"], filter: "cn=#{username}", password: password )

    # We need to check that cn is the same as username
    # since the the AD binds usernames with non-ascii chars
    if bind_user.present? && bind_user.first.cn.first.downcase == username
      true
    else
      Rails.logger.info "LDAP: #{username} failed to log in. #{@client.get_operation_result}"
      false
    end
  end

  # Update user attributes from the ldap user
  def update_user_profile(user)
    Paperclip.options[:log] = false

    # Fetch user attributes
    ldap_user = @client.search(base: APP_CONFIG['ldap']['base_dn'], filter: "cn=#{user.username.downcase}",
        attributes: %w(cn givenname sn displayname mail telephonenumber mobile
            title manager extensionattribute1 roomnumber streetaddress
            company physicaldeliveryofficename houseidentifier division department)).first

    if ldap_user.present?
      @address = { dashboard: user.address, ldap: ldap_user['streetaddress'].first }

      user.first_name                    = ldap_user['givenname'].first || user.username
      user.last_name                     = ldap_user['sn'].first || user.username
      user.displayname                   = ldap_user['displayname'].first || user.username
      user.title                         = ldap_user['title'].first
      user.email                         = ldap_user['mail'].first || "#{user.username}@malmo.se"
      user.company                       = ldap_user['company'].first
      user.department                    = ldap_user['division'].first
      user.adm_department                = ldap_user['department'].first
      user.house_identifier              = ldap_user['houseidentifier'].first
      user.physical_delivery_office_name = ldap_user['physicaldeliveryofficename'].first
      user.address                       = ldap_user['streetaddress'].first if user.address.blank? # Selective sync
      user.room                          = ldap_user['roomnumber'].first if user.room.blank? # Selective sync
      user.manager                       = User.where(username: extract_cn(ldap_user["manager"].first)).first
      user.phone                         = phone ||= ldap_user['telephonenumber'].first
      user.cell_phone                    = cell_phone ||= ldap_user['mobile'].first

      # Activate the user if previsously deactivated
      user.deactivated    = false
      user.deactivated_at = nil

      @user_profile_changed = user.changed?
      user.save(validate: false)
      user
    else
      Rails.logger.info "LDAP: couldn't find #{user.username}. #{@client.get_operation_result}"
      false
    end
  end

  # Extract username from a ldap cn record
  def extract_cn(dn)
    dn[/cn=(.+?),/i, 1].to_s unless dn.blank?
  end

  def find_user(username)
    ldap_user = @client.search(base: APP_CONFIG['ldap']['base_dn'], filter: "cn=#{username}").first
    if ldap_user.present?
      Rails.logger.info ldap_user.inspect
      puts "ldap_user['givenname']: #{ldap_user['givenname'].first}"
      puts "ldap_user['sn']: #{ldap_user['sn'].first}"
      puts "ldap_user['displayname']: #{ldap_user['displayname'].first}"
      puts "ldap_user['title']: #{ldap_user['title'].first}"
      puts "ldap_user['mail']: #{ldap_user['mail'].first}"
      puts "ldap_user['company']: #{ldap_user['company'].first}"
      puts "ldap_user['division']: #{ldap_user['division'].first}"
      puts "ldap_user['department']: #{ldap_user['department'].first}"
      puts "ldap_user['houseidentifier']: #{ldap_user['houseidentifier'].first}"
      puts "ldap_user['physicaldeliveryofficename']: #{ldap_user['physicaldeliveryofficename'].first}"
      puts "ldap_user['streetaddress']: #{ldap_user['streetaddress'].first}"
      puts "ldap_user['roomnumber']: #{ldap_user['roomnumber'].first}"
      puts "ldap_user['telephonenumber']: #{ldap_user['telephonenumber'].first}"
      puts "ldap_user['mobile']: #{ldap_user['mobile'].first}"
      puts "ldap_user['manager']: #{ldap_user['manager'].first}"
      puts "extracted manager cn: #{extract_cn(ldap_user['manager'].first)}"
    else
      Rails.logger.debug "No user #{username}"
    end
    Rails.logger.debug @client.get_operation_result
  end
end
