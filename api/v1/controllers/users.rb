module V1
  module Controllers
    class Users < ::V1::Base
      KEYS = [:email, :phone]

      desc 'User Feature'
      resource :users do

        desc 'Get post detail'
        get ':id' do
          @user = User.find(params[:id])
          error!("User not found", 404) if @user.blank?
          present @user, with: Entities::User
        end
      end

    end
  end
end
