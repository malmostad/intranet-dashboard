Dashboard::Application.configure do
  config.cache_classes = false
  config.action_controller.perform_caching = false
  config.cache_store = :memory_store

  config.whiny_nils = true
  config.consider_all_requests_local = true
  config.log_level = :info
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log

  config.action_dispatch.best_standards_support = :builtin

  config.active_record.mass_assignment_sanitizer = :strict

  config.assets.debug = true
  config.assets.compress = false

  config.action_mailer.default_url_options = { host: 'www.local.malmo.se:3000' }
  config.action_mailer.delivery_method = :test

  Paperclip.options[:command_path] = "/usr/local/bin/convert"
end
