class TodayLastestComponentWorker < BaseWorker
  def perform
    posts = Post.today.published.order('created_at desc').limit(6)
    posts_count = Post.today.published.count
    Redis::HashKey.new('posts')['today_lastest'] =
     [
      :posts => JSON.parse(posts.to_json(
        :only => [:id, :title, :url_code],
        :include => {
          :column => {
            :only => [:id, :name, :slug]}})),
      :posts_count => posts_count
    ].to_json
  end
end