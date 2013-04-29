def login(username, password)
  visit login_path
  fill_in 'username', with: username
  fill_in 'password', with: password
  click_button 'Logga in'
end

def create_user_and_login
  user = FactoryGirl.create(:user, username: AUTH_CREDENTIALS["username"])
  login(user.username, AUTH_CREDENTIALS["password"])
  user
end

def create_user_with_roles_with_feeds
  1.upto(100) {|n| FactoryGirl.create(:role, category: Role::CATEGORIES.keys[n % Role::CATEGORIES.size]) }
  1.upto(20)  {|n|
    f = FactoryGirl.build(:feed,
      category: Feed::CATEGORIES.keys[n % Feed::CATEGORIES.size],
      feed_url: File.join(Rails.root, "spec/samples/whitehouse.rss")
    )
    f.fetch
    f.parse
    f.parsed_feed.entries.each { |fe| fe.entry_id = "fe-#{n}-#{Kernel.rand(0..1000)}" }
    f.save(validate: false)
  }
  Feed.all.each { |f| f.role_ids = Role.all.each.map(&:id) }

  user = FactoryGirl.create(:user)
  user.role_ids = Role.all.each.map(&:id)
  user
end