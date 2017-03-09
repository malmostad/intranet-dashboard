ENV["RAILS_ENV"] ||= 'local_test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'factory_girl_rails'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'database_cleaner'
require 'yaml'

AUTH_CREDENTIALS = YAML.load_file("#{Rails.root.to_s}/spec/auth_credentials.yml")

SAMPLE_FEEDS = [
  "http://feeds.feedburner.com/Techcrunch",
  "http://feeds.feedburner.com/AmazonWebServicesBlog",
  "https://www.theguardian.com/world/rss"
]

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, window_size: [1400, 1000])
end
Capybara.javascript_driver = :poltergeist
Capybara.default_max_wait_time = 5

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.raise_errors_for_deprecations!

  config.infer_spec_type_from_file_location!

  config.mock_with :rspec
  config.infer_base_class_for_anonymous_controllers = true
  config.include Capybara::DSL
  config.include FactoryGirl::Syntax::Methods
  config.order = "random"

  config.use_transactional_fixtures = true

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.include Requests::JsonHelpers, type: :request

  # config.before(:all) do
  #   DatabaseCleaner.clean_with(:truncation)
  # end

  # config.before(:each) do
  #   DatabaseCleaner.strategy = :transaction
  # end

  # config.before(:each, :js => true) do
  #   DatabaseCleaner.strategy = :truncation
  # end

  # config.before(:each) do
  #   DatabaseCleaner.start
  # end

  # config.after(:each) do
  #   DatabaseCleaner.clean
  # end
end
