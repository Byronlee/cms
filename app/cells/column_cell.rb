class ColumnCell < Cell::Rails
  helper ApplicationHelper

  def weekly_hot_posts(args)
    @column = args[:column]
    @posts = @column.posts.published.by_week.order('views_count desc').limit 15
    render
  end
end
