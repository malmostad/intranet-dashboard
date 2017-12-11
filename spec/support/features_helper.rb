def login(username, password)
  visit login_path
  fill_in 'username', with: username
  fill_in 'password', with: password
  click_button 'Logga in'
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
