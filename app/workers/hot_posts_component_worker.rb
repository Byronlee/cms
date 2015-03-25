class HotPostsComponentWorker < BaseWorker
  def perform
    #取最近的50篇，按照访问量排序取前6个
    post_news = Post.published.order("published_at desc").limit(50)
    posts = post_news.sort{|a, b| b.views_count <=> a.views_count}[0..5]
    Redis::HashKey.new('posts')['hot_posts'] = posts.to_json(:only => [:id, :title, :url_code], :methods => [:cover_real_url])
  end
end
