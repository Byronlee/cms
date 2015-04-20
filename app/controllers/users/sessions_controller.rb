class Users::SessionsController < Devise::SessionsController
  def new
    redirect_to user_omniauth_authorize_path(provider: :krypton)
  end

  def after_sign_out_path_for(user)
    params[:ok_url].presence || super
  end
end
