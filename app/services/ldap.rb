# -*- coding: utf-8 -*-
class Ldap
  attr_reader :user_profile_changed

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
    return false if username.strip.empty? || password.strip.empty?

    bind_user = @client.bind_as(base: APP_CONFIG["ldap"]["base_dn"], filter: "cn=#{username}", password: password )
    if bind_user.present?
      true
    else
      Rails.logger.warn "LDAP: #{username} failed to log in. #{@client.get_operation_result}"
      false
    end
  end

  # Update user attributes from the ldap user
  def update_user_profile(username)
    Paperclip.options[:log] = false

    # Fetch user attributes
    ldap_user = @client.search(base: APP_CONFIG['ldap']['base_dn'], filter: "cn=#{username}",
        attributes: %w(cn givenname sn displayname mail telephonenumber mobile title company manager extensionattribute1 division roomnumber streetaddress)).first

    if ldap_user.present?
      # Find existing user or create a new
      user = User.where(username: username).first_or_initialize

      user.first_name    = ldap_user['givenname'].first
      user.last_name     = ldap_user['sn'].first
      user.displayname   = ldap_user['displayname'].first
      user.title         = ldap_user['title'].first
      user.email         = ldap_user['mail'].first
      user.company       = ldap_user['company'].first
      user.department    = ldap_user['division'].first
      user.address       = ldap_user['streetaddress'].first
      user.room          = ldap_user['roomnumber'].first
      user.manager       = User.where(username: extract_cn(ldap_user["manager"].first)).first
      user.phone         = phone ||= ldap_user['telephonenumber'].first
      user.cell_phone    = cell_phone ||= ldap_user['mobile'].first
      @user_profile_changed = user.changed?
      user.save(validate: false)
      user
    else
      Rails.logger.info "LDAP: couldn't find #{username}. #{@client.get_operation_result}"
      return false
    end
  end

  # Extract username from a ldap cn record
  def extract_cn(dn)
    dn[/cn=(.+?),/i, 1] unless dn.blank?
  end

  def find_user(username)
    ldap_user = @client.search(base: APP_CONFIG['ldap']['base_dn'], filter: "cn=#{username}").first
    if ldap_user.present?
      Rails.logger.info ldap_user.inspect
      # Rails.logger.debug ldap_user['dn'].first
      # Rails.logger.debug ldap_user['displayname'].first
      # Rails.logger.debug extract_cn(ldap_user["manager"].first)
      Rails.logger.info ldap_user["department"].first
      Rails.logger.info ldap_user['division'].first
      puts ldap_user['division'].first
      puts ldap_user['roomnumber'].first
      puts ldap_user['streetaddress'].first
    else
      Rails.logger.debug  "No user #{username}"
    end
    Rails.logger.debug  @client.get_operation_result
  end
end
