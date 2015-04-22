require File.expand_path('../observers/post_sweeper.rb', __FILE__)
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  prepend_before_action :match_krid_online_status, unless: -> { devise_controller? || Rails.env.test? }
  prepend_before_action :redirect_to_no_subdomain # i'll run first

  def redirect_to_no_subdomain
    if request.path !~ /^(api|feed).*/ && (subdomain = request.subdomain).present? && subdomain == 'www'
      redirect_to request.original_url.sub("#{subdomain}.36kr.com", '36kr.com')
    end
  end

  def match_krid_online_status
    if (cookie_version = cookies[Settings.oauth.krypton.cookie.name]).present?
      if !current_user || cookie_version.to_i != current_user.krypton_authentication.version
        redirect_to user_omniauth_authorize_path(provider: :krypton, ok_url: request.fullpath)
      end
    elsif current_user
      sign_out(current_user)
    end
  end

  rescue_from CanCan::AccessDenied do
    if current_user
      respond_to do |format|
        format.html { render file: 'errors/forbidden', status: :forbidden, layout: nil }
        format.all { render nothing: true, status: :forbidden }
      end
    else
      respond_to do |format|
        format.html { redirect_to new_user_session_path(ok_url: params[:ok_url]) }
        format.all { render nothing: true, status: :unauthorized }
      end
    end
  end

  def controller_namespace
    controller_name_segments = params[:controller].split('/')
    controller_name_segments.pop
    controller_name_segments.join('/').camelize
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, controller_namespace)
  end

  def append_info_to_payload(payload)
    super
    payload[:host] = request.host
  end

  def ok_url_or(url)
    params[:ok_url] || url
  end
  helper_method :ok_url_or
end
