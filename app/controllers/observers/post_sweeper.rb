class PostSweeper < ActionController::Caching::Sweeper
  observe Post
  def before_save(post)
    return unless @controller
    post.record_laster_update_user(current_user, "#{@controller.controller_path}##{@controller.action_name}")
  end
end
