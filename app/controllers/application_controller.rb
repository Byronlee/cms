class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action do
    unless cookies[:hot_cleared_at]
      cookies.clear
      cookies[:hot_cleared_at] = { value: Time.now.iso8601, domain: :all }
    end
  end

   prepend_before_filter :match_krid_online_status
   skip_before_filter :match_krid_online_status, if: -> { devise_controller? }

   def match_krid_online_status
     if (cookie_version = cookies[Settings.oauth.krypton.cookie.name]).present?
       if !current_user || # 在线状态不同步
         cookie_version.to_i != current_user.krypton_authentication.version || # 资料版本不同步
         Time.now > current_user.krypton_authentication.updated_at + 1.hour # 定时更新解决跨浏览器更新资料
         session["omniauth.ok_url"] = request.fullpath
         redirect_to user_omniauth_authorize_path(provider: :krypton)
       end
     elsif current_user
       sign_out(current_user)
     end
   end

  rescue_from CanCan::AccessDenied do |ex|
    if request.env['HTTP_REFERER']
      redirect_to :back, :alert => ex.message
    else
      redirect_to root_path
    end
  end

  def controller_namespace
    controller_name_segments = params[:controller].split('/')
    controller_name_segments.pop
    controller_name_segments.join('/').camelize
  end

  def current_ability
    Ability.new(current_user, controller_namespace)
  end
end
