class PostService
  def self.today_lastest
    posts_data = Redis::HashKey.new('posts')['today_lastest']
    return  { count: 0, posts: [] } if posts_data.blank?
    hash_data = JSON.parse(posts_data)[0]
    posts = hash_data['posts']
    posts_count = hash_data['posts_count']
    { count: posts_count, posts: posts }
  end
end
