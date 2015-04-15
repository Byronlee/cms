class CacheClient
  include Singleton

  def hot_posts
    Redis::HashKey.new('posts')['hot_posts']
  end

  def excellent_comments
    Redis::HashKey.new('comments')['excellent']
  end

  def today_lastest
    Redis::HashKey.new('posts')['today_lastest']
  end
end
