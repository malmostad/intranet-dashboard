Dashboard::Application.configure do
  config.cache_classes = true
  config.eager_load = true

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.static_cache_control = "public, max-age=3600"
  config.serve_static_files = false
  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :yui
  config.assets.compile = false
  config.assets.digest = true

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify
end
