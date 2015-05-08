class Admin::DashboardController < Admin::BaseController
  authorize_object :dashboard

  def index
    @posts = Post.today.published.includes({ author: :krypton_authentication }, :column, :tags).order("views_count desc")
  end
end
