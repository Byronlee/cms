class Admin::UsersController < Admin::BaseController
  load_and_authorize_resource

  def index
    @users = @users.includes(:krypton_authentication).order('id desc').page params[:page]
  end

  def update
    @user.update(user_params)
    ok_url = (can? :manage, User) ? admin_users_path : edit_admin_user_path(@user)
    respond_with @user, location: ok_url
  end

  def edit
  end

  private

  def user_params
    params.require(:user).permit(:role, :name, :email, :phone, :tagline) if params[:user]
  end
end
