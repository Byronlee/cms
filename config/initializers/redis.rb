redis_config = YAML.load_file(Rails.root + 'config/redis.yml')[Rails.env]

if redis_config
  redis = Redis.new(host: redis_config['host'], port: redis_config['port'])
  $redis = Redis::Objects.redis = Redis::Namespace.new("#{Settings.redis_env.namespace}_krypton_#{Rails.env}", redis: redis)
end
