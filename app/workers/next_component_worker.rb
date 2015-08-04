class NextComponentWorker < BaseWorker
  # sidekiq_options :queue => :third_party_next, :backtrace => true

  # def perform
  #   @collections = Faraday.get(Settings.next.collection_api + '?access_token=' + token['access_token']).body
  #   @next_redis_db = Redis::HashKey.new('next').tap { |rc| rc.expire(token['expires_in']) }
  #   @next_redis_db['collections'] = @collections
  # end

  # private

  # def token
  #   JSON.parse(Faraday.new(:url => Settings.next.host).post do |req|
  #     req.headers['Content-Type'] = 'application/json'
  #     req.body = Settings.next.token_params.to_json
  #   end.body)
  # end
end
