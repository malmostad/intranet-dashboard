def login(username, password)
  visit login_path
  fill_in 'username', with: username
  fill_in 'password', with: password
  click_button 'Logga in'
end

# *_named_user is used for LDAP auth with AUTH_CREDENTIALS

def login_named_user
  login(AUTH_CREDENTIALS["username"], AUTH_CREDENTIALS["password"])
end

def create_named_user
  User.where(username: AUTH_CREDENTIALS["username"]).destroy_all
  create(:user, username: AUTH_CREDENTIALS["username"])
end

def create_named_user_and_login
  user = create_named_user
  login(user.username, AUTH_CREDENTIALS["password"])
  user
end

def create_named_user_with_roles_with_feeds
  1.upto(20) do |n|
    create(:role, category: Role::CATEGORIES.keys[n % Role::CATEGORIES.size])
  end

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

  Feed.all.each { |f| f.role_ids = Role.all.each.map(&:id) }

  user = create_named_user
  user.role_ids = Role.all.each.map(&:id)
  user
end