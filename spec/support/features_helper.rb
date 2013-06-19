def login(username, password)
  visit login_path
  fill_in 'username', with: username
  fill_in 'password', with: password
  click_button 'Logga in'
end

# *_ldap_user is used for LDAP auth with AUTH_CREDENTIALS
def create_ldap_user
  create(:user, username: AUTH_CREDENTIALS["username"])
end

def login_ldap_user
  login(AUTH_CREDENTIALS["username"], AUTH_CREDENTIALS["password"])
end

def create_feeds_for_user(user)
  1.upto(20) do |n|
    f = build(:feed,
      category: Feed::CATEGORIES.keys[n % Feed::CATEGORIES.size],
      feed_url: File.join(Rails.root, "spec/samples/whitehouse.rss") # TODO: use remote feeds and cache with VCR
    )
    f.fetch
    f.parse
    f.parsed_feed.entries.each { |fe| fe.entry_id = "fe-#{n}-#{Kernel.rand(0..1000)}" }
    f.save(validate: false)
  end

  Feed.all.each { |f| f.role_ids = user.roles.each.map(&:id) }
  user
end
