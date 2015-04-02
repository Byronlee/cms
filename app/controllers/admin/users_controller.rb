class Admin::UsersController < Admin::BaseController
  load_resource
  authorize_resource

  def index
    @users = (simple_search if can_search? rescue @users)
    @users = @users.includes(:krypton_authentication).order('id desc').page params[:page]
  end

  def update
    @user.update(user_params)
    ok_url = (can? :manage, User) ? admin_users_path : edit_admin_user_path(@user)
    respond_with @user, location: ok_url
  end

  def shutup
    @user.shutup!
    respond_with @user, location: ok_url_or([:admin, :users])
  end

  def speak
    @user.speak!
    respond_with @user, location:  ok_url_or([:admin, :users])
  end

private

  def user_params
    params.require(:user).permit(:role, :name, :email, :phone, :tagline) if params[:user]
  end

  def simple_search
    type = params[:s][:type]
    return User.where(id: params[:s][:id]) if type.eql?('id')
    User.where("#{type} like '%#{params[:s][type.to_sym]}%'")
  end

  def can_search?
    current_user.role.admin? && params[:s][:type].present?
  end
end
