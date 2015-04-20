class FavoritesController < ApplicationController
  load_and_authorize_resource

  def create
    return render :json => { success: 'false' } if params[:url_code].blank?
    post = Post.find_by_url_code(params[:url_code])
    unless current_user.favorite_of? post
      Favorite.create(:user_id => current_user.id, :url_code => post.url_code)
      render :json => { success: 'add', count: post.reload.favorites_count }
    else
      Favorite.where(url_code: post.url_code, user_id: current_user.id).destroy_all
      render :json => { success: 'del', count: post.reload.favorites_count }
    end
  end
end
