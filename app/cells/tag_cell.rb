class TagCell < Cell::Rails
  helper ApplicationHelper

  def weekly_hot_posts(args)
    @tag = args[:tag]
    @posts = Post.by_week.published.tagged_with(@tag).order('views_count desc').limit 15
    render
  end
end
