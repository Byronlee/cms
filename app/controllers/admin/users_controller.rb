class Admin::UsersController < Admin::BaseController
  load_resource
  authorize_resource

  def index
    @users = (simple_search if can_search? rescue @users.includes(:krypton_authentication))
    @users = @users.order('id desc').page params[:page]
  end

  def update
    @user.assign_attributes(user_params)
    valid = @user.role_changed? && @user.valid?
    flash[:notice] = SyncRoleToWriterWorker.new.perform(@user.krypton_authentication.uid, params[:user][:role]) if @user.save && valid
    ok_url = (can? :manage, User) ? admin_users_path : edit_admin_user_path(@user)
    respond_with @user, location: ok_url
  end

  def shutup
    @user.shutup!
    flash[:notice] = '禁言操作成功！'
    respond_with @user, location: ok_url_or([:admin, :users])
  end

  def speak
    @user.speak!
    flash[:notice] = '解除禁言操作成功！'
    respond_with @user, location:  ok_url_or([:admin, :users])
  end

  private

  def user_params
    # TODO 重构
    return {} unless params[:user]
    role = current_user.role.admin? ? params.require(:user).permit(:role) : {}
    if current_user.role.admin?
      domain = params.require(:user).permit(:domain)
      domain.each {|k,v| v.downcase!}
    else
      domain = {}
    end
    other = params.require(:user).permit(:tagline)
    other.merge(role).merge(domain)
  end

  def simple_search
    @type_value = params[:s][params[:s][:type].to_sym]
    return User.where(id: params[:s][:id]).includes(:krypton_authentication) if params[:s][:type].eql?('id')
    return User.where(sso_id: params[:s][:sso_id]).includes(:krypton_authentication) if params[:s][:type].eql?('sso_id')
    return User.where(role:params[:s][:role]).includes(:krypton_authentication) if params[:s][:type].eql?('role')
    User.joins(:krypton_authentication).where("authentications.raw like '%#{params[:s][params[:s][:type].to_sym]}%'")
  end

  def can_search?
    current_user.role.admin? && params[:s][:type].present?
  end
end
