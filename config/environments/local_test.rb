Dashboard::Application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  config.consider_all_requests_local = true
  config.log_level = :info
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log

  config.assets.debug = true

  config.action_mailer.default_url_options = { host: 'www.local.malmo.se:3000' }
  config.action_mailer.delivery_method = :test

  Paperclip.options[:command_path] = "/usr/local/bin/convert"
end
