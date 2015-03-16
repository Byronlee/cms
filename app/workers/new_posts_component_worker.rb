class  NewPostsComponentWorker < BaseWorker
  def perform
    posts = Post.select([:id, :title, :url_code, :created_at]).tagged_with("startup").order("created_at desc").limit(9)
    newsflashes = Newsflash.select([:id, :hash_title, :created_at]).order("created_at desc").limit(9)
    posts_json = posts.to_json(:methods => [:get_access_url])
    newsflashes_json = newsflashes.to_json
    Redis::HashKey.new('posts')['new_posts'] = "{\"posts\":#{posts_json},\"newsflashes\":#{newsflashes_json}}"
  end
end
