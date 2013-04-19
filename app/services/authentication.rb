# -*- coding: utf-8 -*-

class Authentication
  # Check credentials for a user with an ldap server
  # Return a User object or false
  def self.authenticate(username, password)
    Ldap.authenticate(username, password)
  end

  class Ldap
    def self.authenticate(username, password)
      return stub_auth(username) if APP_CONFIG['ldap_stub']
      return false if username.strip.empty? || password.strip.empty?

      ldap = Net::LDAP.new(
        host: APP_CONFIG["ldap"]["host"],
        port: APP_CONFIG["ldap"]["port"],
        encryption: { method: :simple_tls },
        auth: {
          method: :simple,
          username: "cn=#{username},#{APP_CONFIG['ldap']['base_dn']}",
          password: password
        }
      )

      # Authenticate user
      bind_user = ldap.bind_as(:base => APP_CONFIG["ldap"]["base_dn"], :filter => "cn=#{username}", :password => password )

      # Fetch user attributes
      ldap_user = ldap.search( base: APP_CONFIG['ldap']['base_dn'], filter: "cn=#{username}",
          attributes: %w( cn givenname sn displayname mail telephonenumber mobile title company manager directreports ) )

      if ldap_user.present? && bind_user.present?
        # Find local user or create a new one
        @user = User.find_or_create_by_username(username)
        sync_attributes(ldap_user.first)
        @user
      else
        Rails.logger.warn "LDAP: #{username} failed to log in. #{ldap.get_operation_result}"
        return false
      end
    end

    private

    # Update local user from the ldap user
    def self.sync_attributes(ldap_user)
      @user.first_name    = ldap_user['givenname'].first
      @user.last_name     = ldap_user['sn'].first
      @user.displayname   = ldap_user['displayname'].first
      @user.title         = ldap_user['title'].first
      @user.email         = ldap_user['mail'].first
      @user.company       = ldap_user['company'].first
      @user.manager       = ldap_user["manager"].map { |m| extract_cn(m) }.join(", ")
      @user.directreports = ldap_user["directreports"].map { |m| extract_cn(m) }.join(", ")
      @user.phone         = phone ||= ldap_user['telephonenumber'].first
      @user.cell_phone    = cell_phone ||= ldap_user['mobile'].first
      @user.save
    end

    # Extract username from a ldap cn record
    def self.extract_cn(dn)
      dn[/cn=(.+?),/i, 1] unless dn.blank?
    end

    # Stub auth w/out ldap
    # Returns an **existing** user by username
    def self.stub_auth(username)
      u = User.find_by_username(username)
      u.touch
      u
      rescue
        false
    end
  end
end