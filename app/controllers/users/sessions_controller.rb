class Users::SessionsController < Devise::SessionsController
  def new
    if current_user
      redirect_to params[:ok_url].presence || after_sign_in_path_for(current_user)
    else
      redirect_to user_omniauth_authorize_path(provider: :krypton, ok_url: params[:ok_url])
    end
  end

  def after_sign_out_path_for(user)
    params[:ok_url].presence || super
  end
end
