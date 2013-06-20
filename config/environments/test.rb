Dashboard::Application.configure do

  config.log_level = :info
  config.consider_all_requests_local = false
  config.cache_classes = true
  config.action_controller.perform_caching = true
  # config.cache_store = :mem_cache_store
  config.cache_store = :dalli_store, '127.0.0.1:11211', { namespace: "dashboard-test" }

  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"
  config.assets.compress = true
  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :scss
  config.assets.compile = false
  config.assets.digest = true

  config.whiny_nils = true

  config.action_dispatch.show_exceptions = false
  config.action_controller.allow_forgery_protection    = false

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  config.active_support.deprecation = :log

  config.active_record.mass_assignment_sanitizer = :strict

  # ImageMagick resize. (Use "which convert" path)
  Paperclip.options[:command_path] = "/usr/bin/"
end
