class UsersController < ApplicationController
  load_resource only: :current
  load_and_authorize_resource :favorite, through: :current_user, only: :favorites, parent: false

  def messages
    return render :text => '', layout: false if params['data'].blank? || params['data']['code'].to_i != 0
    render '_messages', layout: false
  end

  def favorites
    @favorites = @favorites.recent.page(params[:page]).per(params[:per_page])
  end

  def cancel_favorites
    post = Post.find_by_url_code params[:url_code]
    @state = false
    unless (current_user.sso_id.blank? or post.blank?)
      if post.favoriter_sso_ids.include? current_user.sso_id
        Favorite.where(url_code: post.url_code, user_id: current_user.id).destroy_all
        @state = false
      else
        Favorite.create(url_code: post.url_code, user_id: current_user.id)
        @state = true
      end
    end
  end
end
