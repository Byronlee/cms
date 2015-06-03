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
    flash[:notice] = "禁言操作成功！"
    respond_with @user, location: ok_url_or([:admin, :users])
  end

  def speak
    @user.speak!
    flash[:notice] = "解除禁言操作成功！"
    respond_with @user, location:  ok_url_or([:admin, :users])
  end

  private

  def user_params
    return {} unless params[:user]
    role = current_user.role.admin? ? params.require(:user).permit(:role) : {}
    if current_user.role.admin?
      domain = params.require(:user).permit(:domain)
      domain.each {|k,v| v.downcase!}
    else
      domain = {}
    end
    other = params.require(:user).permit(:name, :email, :phone, :tagline)
    other.merge(role).merge(domain)
  end

  def simple_search
    @type = params[:s][:type]
    if @type.eql?('id')
      @type_value = params[:s][:id]
      User.where(id: @type_value) 
    elsif @type.eql?('sso_id')
      @type_value = params[:s][:sso_id]
      User.where(sso_id: @type_value)
    else
      @type_value = params[:s][@type.to_sym]
      User.where("#{@type} like '%#{@type_value}%'")
    end      
  end

  def can_search?
    current_user.role.admin? && params[:s][:type].present?
  end
end
