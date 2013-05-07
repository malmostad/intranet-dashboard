source 'http://rubygems.org'

gem 'rails', '3.2.13'
gem 'jquery-rails', '2.2.1'
gem 'haml', '4.0.2'

gem 'nokogiri', '1.5.6'
gem 'feedzirra', '0.2.0.rc2' #, '0.1.3' #, :git => 'https://github.com/pauldix/feedzirra.git'

gem 'net-ldap', '0.3.1'
gem 'ruby-saml', '0.7.0' # 0.7.2 is broken
gem 'bcrypt-ruby', '3.0.1'

gem 'dalli', '2.6.2'
gem 'mysql2', '0.3.11'

gem 'paperclip', '3.4.1'
gem 'cocaine', '0.5.1'

gem 'daemons-rails'

gem 'capistrano', '2.15.4'
gem 'capistrano-ext'
gem 'whenever', require: false

group :development, :local_test do
  gem 'quiet_assets'
  gem 'thin'
end

group :test, :local_test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'guard-rspec'
  gem 'rb-fsevent'
  gem 'launchy'
end

group :assets do
  gem 'sass-rails', '3.2.6'
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '2.0.1'
  gem 'therubyracer', '0.11.4', require: 'v8'
end

group :production do
end

group :'2_0' do
end
