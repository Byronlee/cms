class TodayLastestComponentWorker < BaseWorker
  def perform
    posts = Post.today.order("created_at desc").limit(6)
    posts_count = Post.today.count
    Redis::HashKey.new('posts')['today_lastest'] =
     [
      :posts => posts.to_json(
        :only => [:title],
        :include => {
          :column => {
            :only => [:name]}}),
      :posts_count => posts_count
    ]
  end
end