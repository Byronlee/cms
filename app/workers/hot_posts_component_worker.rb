class HotPostsComponentWorker < BaseWorker
  def perform
    posts = Post.published.hot_posts.by_month.limit 6
    Redis::HashKey.new('posts')['hot_posts'] = posts.to_json(:only => [:id, :title, :url_code], :methods => [:cover_real_url])
  end
end
