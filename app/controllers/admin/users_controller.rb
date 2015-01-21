class Admin::UsersController < Admin::BaseController
  def index
  	@users = User.order("id desc").page params[:page]
  end
end