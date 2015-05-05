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
          .order(created_at: :desc).page(params[:page]).per(params[:per_page])
          cache(key: "api:v2:favorites:#{params[:sso_token]}", etag: Time.now, expires_in: Settings.api.expires_in) do
            #present favorites, with: Entities::Favorite
            posts_list = []
            favorites.each do |favorite|
              posts_list << {
                id: favorite.id,
                url_code: favorite.post.url_code,
                title: favorite.post.title,
                cover_real_url: favorite.post.cover_real_url,
                favoriter_sso_ids: favorite.post.favoriter_sso_ids,
                created_at: favorite.created_at.iso8601,
                updated_at: favorite.updated_at.iso8601
              }
            end
            posts_list
          end
        end

        params do
          optional :sso_token, type: String, desc: 'sso_token'
          optional :url_code, type: Integer, desc: 'url_code'
        end
        post 'new' do
          user = current_user[0]
          post = Post.where(url_code: params[:url_code]).first
          state = false
          unless (user.sso_id.blank? and post.blank?)
            if post.favoriter_sso_ids.include? user.sso_id
              Favorite.where(url_code: post.url_code, user_id: user.id).destroy_all
              state = false
            else
              Favorite.create(url_code: post.url_code, user_id: user.id)
              state = true
            end
          end
          { sso_id: user.sso_id, url_code: post.url_code, favorited: state }
        end
      end

    end
  end
end
