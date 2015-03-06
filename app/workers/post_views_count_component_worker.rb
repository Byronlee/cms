class PostViewsCountComponentWorker < BaseWorker
  def perform(id)
    post = Post.find id
    post.update_attribute(:views_count, Redis::HashKey.new('posts')["views_count_#{id}"])
  end
end