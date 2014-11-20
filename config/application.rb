require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module Dashboard
  class Application < Rails::Application
    config.active_record.whitelist_attributes = false

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{Rails.root}/app/models/concerns)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Stockholm'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = "sv-SE"
    I18n.config.enforce_available_locales = false

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    config.log_tags = [:remote_ip, :user_agent]

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
    config.assets.precompile += %w( legacy/ie7.css legacy/ie9.css legacy/ancient_browser_warning.js )

    config.assets.paths += [
      Rails.root.join("vendor", "malmo_shared_assets", "stylesheets").to_s,
      Rails.root.join("vendor", "malmo_shared_assets", "stylesheets", "shared").to_s,
      Rails.root.join("vendor", "malmo_shared_assets", "stylesheets", "internal").to_s
    ]

    config.action_dispatch.default_headers = {
      'X-UA-Compatible' => 'IE=edge',
      'X-XSS-Protection' => '0'
    }

    config.generators do |g|
      g.template_engine :haml
      g.test_framework :rspec
    end

    # config.middleware.insert_before 0, "EmployeeSearchSuggestions"
  end
end
