def login(username, password)
  visit login_path
  fill_in 'username', with: username
  fill_in 'password', with: password
  click_button 'Logga in'
end

# *_ldap_user is used for LDAP auth with AUTH_CREDENTIALS
def create_ldap_user
  # We have only one test user in the ldap so we need to reuse it. TODO: Create stub for this
  User.where(username: AUTH_CREDENTIALS["username"]).destroy_all
  create(:user, username: AUTH_CREDENTIALS["username"])
end

def login_ldap_user
  login(AUTH_CREDENTIALS["username"], AUTH_CREDENTIALS["password"])
end

def create_feeds_for_user(user)
  feed_urls = %w[
    https://github.com/rspec/rspec/commits.atom
    https://github.com/jnicklas/capybara/commits.atom
    https://github.com/ariya/phantomjs/commits.atom
    https://github.com/jonleighton/poltergeist/commits.atom
    https://github.com/rails/rails/commits.atom
    https://github.com/jquery/jquery/commits.atom
    https://github.com/joyent/node/commits.atom
    https://github.com/capistrano/capistrano/commits.atom
    https://github.com/haml/haml/commits.atom
    https://github.com/nex3/sass/commits.atom
    https://github.com/guard/guard-rspec/commits.atom
    https://github.com/thoughtbot/factory_girl/commits.atom
    https://github.com/vcr/vcr/commits.atom
    https://github.com/chrisk/fakeweb/commits.atom
  ]

  VCR.use_cassette('feeds') do
    feed_urls.each_with_index do |feed_url, i|
      f = build(:feed,
        category: Feed::CATEGORIES.keys[i % Feed::CATEGORIES.size],
        feed_url: feed_url
      )
      f.fetch
      f.parse
      f.save(validate: false)
    end
  end

  Feed.all.each { |f| f.role_ids = user.roles.each.map(&:id) }
  user
end
