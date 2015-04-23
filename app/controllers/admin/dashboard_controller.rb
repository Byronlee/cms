class Admin::DashboardController < Admin::BaseController
  authorize_object :dashboard

  def index
    @posts = Post.today.published
  end
end
