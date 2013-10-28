Dashboard::Application.configure do

  config.cache_classes = false
  config.action_controller.perform_caching = false

  # Note: A cache store must be available since we use key-value caching
  #       With memory_store, some code changes requires a restart of the server
  #config.cache_store = :dalli_store, '127.0.0.1:11211', { namespace: "dashboard-development" }
  config.cache_store = :null_store
  # config.cache_store = :mem_cache_store

  config.whiny_nils = true

  config.consider_all_requests_local = true
  config.log_level = :debug
#  config.colorize_logging = false

  config.action_mailer.raise_delivery_errors = false

  config.active_support.deprecation = :log

  config.action_dispatch.best_standards_support = :builtin

  config.active_record.mass_assignment_sanitizer = :strict

  config.assets.compress = false
  config.assets.debug = true

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: 'www.local.malmo.se:3000' }
  config.action_mailer.delivery_method = :file

  # ImageMagick resize. (Use "which convert" path)
  Paperclip.options[:command_path] = "/usr/local/bin/convert"
end
