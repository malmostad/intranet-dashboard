source 'https://rubygems.org'

gem 'protected_attributes', '1.1.3'

gem 'rails', '4.2.7.1'
gem 'jquery-rails', '4.2.2'
gem 'haml', '4.0.7'

gem 'sass-rails', '5.0.6'
gem 'coffee-rails', '4.2.1'
gem 'uglifier', '3.0.4'

gem 'nokogiri', '1.7.0.1'
gem 'feedjira', '2.1.0'
gem 'savon', '2.11.1'
gem 'siteseeker_normalizer', '0.1.6'

gem 'net-ldap', '0.15.0' # '0.3.1' works, 0.5 and 0.6 (0.10.1?) have an encoding issue: https://github.com/ruby-ldap/ruby-net-ldap/pull/82
gem 'ruby-saml', '1.4.2' # '0.7.0' works, 0.7.1/2 is broken
gem 'bcrypt-ruby', '3.1.5'

gem 'dalli', '2.7.6'
gem 'mysql2', '0.4.5'
gem 'elasticsearch-model', '0.1.9'
gem 'elasticsearch-rails', '0.1.9'
gem 'ansi'

gem 'paperclip', '4.3.1'
gem 'simple_form', '3.3.1'
gem 'daemons', '1.2.4'
gem 'daemons-rails', '1.2.1'
gem 'delayed_job_active_record', '4.1.1'

gem 'capistrano', '~> 3.7.1'
gem 'capistrano-rails', '~> 1.2.0'
gem 'capistrano-rbenv', '~> 2.1.0'
gem 'whenever', '~> 0.9.2', require: false
gem 'highline'
gem 'execjs'

gem 'jbuilder', '2.6.1'
gem 'axlsx', '2.0.1'
gem 'vcardigan', '0.0.9'

gem 'unicorn', group: [:test, :production]

group :development do
  gem 'bullet'
  gem 'haml-rails'
  gem 'pry-rails'
end

group :development, :local_test do
  gem 'quiet_assets'
  gem 'thin'
end

group :local_test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'rack-test'
  gem 'poltergeist'
  gem 'guard-rspec'
  gem 'rb-fsevent'
  gem 'launchy'
  gem 'database_cleaner'
end
