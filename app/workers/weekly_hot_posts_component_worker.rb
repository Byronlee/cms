class WeeklyHotPostsComponentWorker < BaseWorker
  def perform(column_id)
    column = Column.find column_id
    posts = column.posts.published.by_week.order('views_count desc').limit 15
    Redis::HashKey.new('posts')['weekly_hot'] = posts.to_json(:only => [:id, :title, :created_at, :views_count])
  end
end