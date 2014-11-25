source 'http://rubygems.org'

gem 'protected_attributes'

gem 'rails', '4.1.8'
gem 'jquery-rails', '3.1.2'
gem 'haml', '4.0.5'

gem 'nokogiri', '1.6.4.1'
gem "feedjira", "1.5.0"
gem 'savon', '2.8.0'
gem 'siteseeker_normalizer', '0.1.3'

gem 'net-ldap', '0.3.1' # '0.3.1' works, 0.5 and 0.6 have an encoding issue: https://github.com/ruby-ldap/ruby-net-ldap/pull/82
gem 'ruby-saml', '0.7.0' # 0.7.1/2 is broken
gem 'bcrypt-ruby', '3.1.5'

gem 'dalli', '2.7.2'
gem 'mysql2', '0.3.17'
gem 'elasticsearch-model', '0.1.6'
gem 'elasticsearch-rails', '0.1.6'
gem 'ansi'

gem 'paperclip', '4.2.0'
gem 'simple_form', '3.0.2'
gem 'daemons', '1.1.9'
gem 'daemons-rails', '1.2.1'
gem 'delayed_job_active_record', '4.0.2'

gem 'capistrano', '~> 2.15.5'
gem 'capistrano-ext'
gem 'whenever', require: false

gem 'jbuilder', '2.2.5'
gem 'axlsx', '2.0.1'
gem 'vcardigan', '0.0.6'

gem 'macaddr', '1.7.1'
gem 'net-ssh', '2.7.0' # No prompt for pw in 2.8.0

group :development do
  gem 'haml-rails'
  gem 'pry-rails'
end

group :development, :test do
  # gem 'rack-mini-profiler'
end

group :development, :local_test do
  gem 'quiet_assets'
  gem 'thin'
end

group :local_test do
  gem 'rspec-rails', '~> 2.99.0'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'rack-test'
  gem 'poltergeist'
  gem 'guard-rspec'
  gem 'rb-fsevent'
  gem 'launchy'
  gem 'database_cleaner'
end

gem 'sass-rails', '4.0.4'
gem 'coffee-rails', '4.1.0'
gem 'uglifier', '2.5.3'
gem 'therubyracer', '0.12.1', require: 'v8'
