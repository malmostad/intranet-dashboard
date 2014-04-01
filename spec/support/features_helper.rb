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
  feed_urls = Dir.glob(Rails.root.join("spec", "samples", "feeds") + "*.xml")

  feed_urls.each_with_index do |feed_url, i|
    f = build(:feed,
      category: Feed::CATEGORIES.keys[i % Feed::CATEGORIES.size],
      feed_url: "file://#{feed_url}"
    )
    f.save
  end

  Feed.all.each { |f| f.role_ids = user.roles.each.map(&:id) }
  user
end
