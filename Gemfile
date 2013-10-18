source 'http://rubygems.org'

gem 'rails', '3.2.15'
gem 'jquery-rails', '3.0.4'
gem 'haml', '4.0.3'

gem 'nokogiri', '1.6.0'
gem 'feedzirra', '0.2.1'
gem 'savon', git: 'https://github.com/savonrb/savon.git', branch: 'master' #, '2.3.0'

gem 'net-ldap', '0.3.1'
gem 'ruby-saml', '0.7.0' # 0.7.1/2 is broken
gem 'bcrypt-ruby', '~> 3.0.0'

gem 'dalli', '2.6.4'
gem 'mysql2', '0.3.13'

gem 'paperclip', '3.5.1'
gem 'simple_form', '2.1.0'

gem 'daemons-rails', '1.2.1'

gem 'capistrano', '~> 2.15.5'
gem 'capistrano-ext'
gem 'whenever', require: false

gem 'jbuilder', '1.5.2'

group :development do
  gem 'haml-rails'
end

group :development, :local_test do
  gem 'quiet_assets'
  gem 'thin'
end

group :local_test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'poltergeist'
  gem 'guard-rspec'
  gem 'rb-fsevent'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'vcr'
  gem 'webmock', '1.13.0'
end

group :assets do
  gem 'sass-rails', '3.2.6'
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '2.2.1'
  gem 'therubyracer', '0.12.0', require: 'v8'
end

group :production do
end

group :'2_0' do
end
