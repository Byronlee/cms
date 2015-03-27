class FavoritesController < ApplicationController
  load_and_authorize_resource

  def create
    return render :json => { success: 'false' } if params[:post_id].blank?
    post = Post.find(params[:post_id])
    unless current_user.favorite_of? post.id
      current_user.favorite_posts << post
      render :json => { success: 'add', count: post.favoriters.count }
    else
      Favorite.where(post_id: post.id, user_id: current_user.id).destroy_all
      render :json => { success: 'del', count: post.favoriters.count }
    end
  end
end
