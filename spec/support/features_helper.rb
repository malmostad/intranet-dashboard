def login(username, password)
  visit login_path
  fill_in 'username', with: username
  fill_in 'password', with: password
  click_button 'Logga in'
end

# *_ldap_user is used for LDAP auth with AUTH_CREDENTIALS
def create_ldap_user
  # We have only one test user in the ldap so we need to reuse it
  User.where(username: AUTH_CREDENTIALS["username"]).destroy_all
  create(:user, username: AUTH_CREDENTIALS["username"])
end

def login_ldap_user
  login(AUTH_CREDENTIALS["username"], AUTH_CREDENTIALS["password"])
end

def create_feeds_for_user(user)
  SAMPLE_FEEDS.each_with_index do |feed_url, i|
    create(:feed,
      category: Feed::CATEGORIES.keys[i % Feed::CATEGORIES.size],
      feed_url: feed_url
    )
  end

  Feed.all.each { |f| f.role_ids = user.roles.each.map(&:id) }
end
