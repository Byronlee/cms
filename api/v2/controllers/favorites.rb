module V2
  module Controllers
    class Favorites < ::V2::Base

      desc 'Favorites Feature'
      resource :favorites do
        params do
          optional :sso_token, type: String, desc: 'sso_token'
        end
        get do
          user = current_user[0]
          favorites = Favorite.where(user_id: user.id)
          present favorites, with: Entities::Favorite
        end

      end

    end
  end
end
