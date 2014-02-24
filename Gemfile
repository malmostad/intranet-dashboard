source 'http://rubygems.org'

gem 'rails', '3.2.17'
gem 'jquery-rails', '3.1.0'
gem 'haml', '4.0.5'

gem 'nokogiri', '1.6.1'
gem "feedzirra", "0.7.0"
gem 'savon', '2.3.3'
gem 'siteseeker_normalizer', '0.1.1'

gem 'net-ldap', '0.3.1'
gem 'ruby-saml', '0.7.0' # 0.7.1/2 is broken
gem 'bcrypt-ruby', '~> 3.0.1'

gem 'dalli', '2.7.0'
gem 'mysql2', '0.3.14'
gem 'elasticsearch-model', git: 'https://github.com/elasticsearch/elasticsearch-rails.git'
gem 'elasticsearch-rails', git: 'https://github.com/elasticsearch/elasticsearch-rails.git'
gem 'ansi'

gem 'paperclip', '3.5.2'
gem 'simple_form', '2.1.1'
gem 'daemons', '1.1.9'
gem 'delayed_job_active_record', '4.0.0'

gem 'daemons-rails', '1.2.1'

gem 'capistrano', '~> 2.15.5'
gem 'capistrano-ext'
gem 'whenever', require: false

gem 'jbuilder', '2.0.2'
gem 'axlsx', '2.0.1'

gem 'macaddr', '1.6.1' # 1.6.2 has a depend issue with systemu

group :development do
  gem 'haml-rails'
  gem 'pry-rails'
end

group :development, :test do
  gem 'rack-mini-profiler'
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
  gem 'guard-rspec', '4.2.4'
  gem 'rb-fsevent'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'vcr'
  gem 'webmock', '1.13.0'
end

group :assets do
  gem 'sass-rails', '3.2.6'
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '2.4.0'
  gem 'therubyracer', '0.12.0', require: 'v8'
end

group :production do
end

group :'2_0' do
end
