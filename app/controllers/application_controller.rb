class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  prepend_before_action :match_krid_online_status, unless: -> { devise_controller? }
  prepend_before_action :redirect_to_no_subdomain # i'll run first

  def redirect_to_no_subdomain
    if request.path !~ /^(api|feed).*/ && (subdomain = request.subdomain).present? && subdomain == 'www'
      redirect_to request.original_url.sub("#{subdomain}.36kr.com", '36kr.com')
    end
  end
  before_action do
    unless cookies[:_3_hot_recleared_at]
      cookies.clear domain: :all
      cookies[:_3_hot_recleared_at] = { value: Time.now.iso8601, domain: :all }
    end
  end

  def match_krid_online_status
    if (cookie_version = cookies[Settings.oauth.krypton.cookie.name]).present?
      if !current_user || # 在线状态不同步
        cookie_version.to_i != current_user.krypton_authentication.version || # 资料版本不同步
        Time.now > current_user.krypton_authentication.updated_at + 1.hour # 定时更新解决跨浏览器更新资料
        session["omniauth.ok_url"] = request.original_url
        Rails.logger.info "重新授权，跳转前 url: #{request.original_url}, fullpath: #{request.fullpath}"
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
