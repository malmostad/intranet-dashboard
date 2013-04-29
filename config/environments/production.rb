Dashboard::Application.configure do

  config.log_level = :warn
  config.action_controller.relative_url_root = "/dashboard"
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

  Paperclip.options[:command_path] = "/usr/bin/"
end