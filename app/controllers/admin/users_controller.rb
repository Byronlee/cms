class Admin::UsersController < Admin::BaseController

  def index  
  	@users = User.include(:krypton_authentication).send(params[:role].to_sym) rescue User.all 
  	@users = @users.page params[:page]
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