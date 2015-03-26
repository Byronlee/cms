class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  #def failure
  #  Rails.logger.error "获取通行证授权失败，错误原因：#{failure_message}"
  #  flash[:alert] = "很抱歉，由于某些原因导致登录失败，请稍后重试。"
  #  redirect_to root_path
  #end

  def krypton
    omniauth = request.env["omniauth.auth"]
    format = params[:state] == "iframe" ? :iframe : :html
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'].to_s)
    if authentication
      authentication.update_attributes omniauth: omniauth
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect_to_iframe_or_parent(authentication.user)
    # 根据邮箱进行匹配找到老用户并绑定
    elsif omniauth["info"]["email"].present? && (user = User.find_by_email(omniauth["info"]["email"]))
      # 为避免出现自毁重复问题，清理掉残留数据
      user.authentications.destroy_all
      user.authentications.create! omniauth: omniauth
      flash[:notice] = "Authentication successful."
      sign_in_and_redirect_to_iframe_or_parent(user)
    # 根据社交帐号伪造的邮箱进行匹配 "provider+uid@36kr.com"
    elsif user = User.find_by_origin_ids(omniauth["uid"])
      # 为避免出现自毁重复问题，清理掉残留数据
      user.authentications.destroy_all
      user.authentications.create! omniauth: omniauth
      flash[:notice] = "Authentication successful."
      sign_in_and_redirect_to_iframe_or_parent(user)
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect_to_iframe_or_parent(user)
      else
        session[:omniauth] = omniauth
        if params[:state] == "iframe"
          render html: "<script>parent.location.href = '#{new_user_registration_url}';</script>".html_safe
        else
          redirect_to new_user_registration_url
        end
      end
    end
  end

  def after_sign_in_path_for(resource)
    session.delete("omniauth.ok_url") || super
  end

  def sign_in_and_redirect_to_iframe_or_parent(user)
    sign_in(user, bypass: true)
    if params[:state] == "iframe"
      render html: "<script>parent.location.reload();</script>".html_safe
    else
      redirect_to after_sign_in_path_for(user)
    end
  end
end
