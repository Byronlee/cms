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

  def info_flow
    Redis::HashKey.new('info_flow')[InfoFlow::DEFAULT_INFOFLOW]
  end

  def head_lines
    Redis::HashKey.new('head_lines')['list']
  end

  def columns_header
    Redis::HashKey.new('columns')['header']
  end
end
