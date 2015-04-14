class CacheClient
  include Singleton

  def hot_posts
    Redis::HashKey.new('posts')['hot_posts']
  end
end
