class Admin::UsersController < Admin::BaseController
  load_and_authorize_resource

  def index
    @users = @users.includes(:krypton_authentication).page params[:page]
  end

  def update
    @user.update(user_params)
    respond_with @user, location: admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:role) if params[:user]
  end
end
