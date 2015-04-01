config = {
  host: Settings.elasticsearch_servers,
  transport_options: {
    request: { timeout: 10 }
  },
}

if File.exists?("config/elasticsearch.yml")
  config.merge!(YAML.load_file("config/elasticsearch.yml").symbolize_keys)
end

Elasticsearch::Model.client = Elasticsearch::Client.new(config)
