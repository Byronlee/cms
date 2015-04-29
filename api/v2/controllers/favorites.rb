module V2
  module Controllers
    class Favorites < ::V2::Base

      desc 'Favorites Feature'
      resource :favorites do
        params do
          optional :sso_token, type: String, desc: 'sso_token'
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
        end
        get do
          user = current_user[0]
          favorites = Favorite.where(user_id: user.id)
            .order(created_at: :desc)
            .page(params[:page]).per(params[:per_page])
          #present favorites, with: Entities::Favorite

          posts_list = []
          favorites.each do |favorite|
            posts_list << {
              id: favorite.id,
              url_code: favorite.post.url_code,
              title: favorite.post.title,
              cover_real_url: favorite.post.cover_real_url,
              created_at: favorite.created_at.iso8601,
              updated_at: favorite.updated_at.iso8601
            }
          end
          posts_list
        end

      end

    end
  end
end
