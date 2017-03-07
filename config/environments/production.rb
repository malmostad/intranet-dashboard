Dashboard::Application.configure do
  config.eager_load = true

  config.log_level = :info
  config.consider_all_requests_local = false
  config.cache_classes = true
  config.action_controller.perform_caching = true
  config.cache_store = :dalli_store, '127.0.0.1:11211', { namespace: "dashboard-production" }

  config.serve_static_files = true
  config.static_cache_control = "public, max-age=3600"
  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :scss
  config.assets.compile = false
  config.assets.digest = true

  config.action_dispatch.show_exceptions = false
  config.action_controller.allow_forgery_protection    = false

  config.active_support.deprecation = :notify

  config.action_mailer.default_url_options = { host: 'minsida.malmo.se' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => "relay.malmo.se",
    :domain               => 'malmo.se',
    :enable_starttls_auto => true,
    :openssl_verify_mode  => 'none'
  }
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true

  Paperclip.options[:command_path] = "/usr/bin/"
end
