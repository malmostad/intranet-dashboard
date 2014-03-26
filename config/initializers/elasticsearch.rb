if Rails.env.development?
  Elasticsearch::Model.client = Elasticsearch::Client.new log:true
  Elasticsearch::Model.client.transport.logger.formatter = proc { |s, d, p, m| "\e[32m#{m}\n\e[0m" }
end

Rails.application.config.elasticsearch = YAML.load_file("#{Rails.root.to_s}/config/elasticsearch.yml")
