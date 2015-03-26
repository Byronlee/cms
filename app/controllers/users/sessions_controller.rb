class Users::SessionsController < Devise::SessionsController
  def new
    if current_user
      redirect_to after_sign_in_path_for(current_user)
    else
      redirect_to user_omniauth_authorize_path(provider: :krypton)
    end
  end
end
