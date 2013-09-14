Dashboard::Application.configure do

  config.log_level = :warn
  config.consider_all_requests_local = false

  config.cache_classes = true
  config.action_controller.perform_caching = true
  config.cache_store = :dalli_store, '127.0.0.1:11211', { namespace: "dashboard-production" }

  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"

  config.assets.compress = true
  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :scss
  config.assets.compile = false
  config.assets.digest = true

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  config.action_mailer.default_url_options = { host: 'webapps06.malmo.se' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => "mail2.malmo.se",
    :domain               => 'malmo.se',
    :enable_starttls_auto => true
  }
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false

  Paperclip.options[:command_path] = "/usr/bin/"
end