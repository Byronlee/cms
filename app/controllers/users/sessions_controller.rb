class Users::SessionsController < Devise::SessionsController
  def new
    redirect_to user_omniauth_authorize_path(provider: :krypton)
  end
end
