APP_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/app_config.yml")[Rails.env]
