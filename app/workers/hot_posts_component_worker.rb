class HotPostsComponentWorker < BaseWorker
  def perform
    posts = Post.hot_posts.limit 6
    Redis::HashKey.new('posts')['hot_posts'] = posts.to_json(:only => [:id, :title], :methods => [:cover_real_url])
  end
end
