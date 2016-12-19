Dashboard::Application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.action_controller.perform_caching = false

  # Note: A cache store must be available since we use key-value caching
  #       With memory_store, some code changes requires a restart of the server
  # config.cache_store = :dalli_store, '127.0.0.1:11211', { namespace: "dashboard-development" }
  config.cache_store = :null_store
  # config.cache_store = :mem_cache_store

  config.consider_all_requests_local = true
  config.log_level = :debug
  config.log_tags = false
#  config.colorize_logging = false

  config.active_support.deprecation = :log

  config.assets.debug = true

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: 'www.local.malmo.se:3000' }
  config.action_mailer.delivery_method = :file

  # ImageMagick resize. (Use "which convert" path)
  Paperclip.options[:command_path] = "/usr/local/bin/convert"

  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.stacktrace_includes = []
  end
end
