class Asynces::FavoritesController < ApplicationController
  load_and_authorize_resource
  skip_before_filter :verify_authenticity_token, if: Proc.new{|c| c.request.xhr?}

  def create
    return render :json => { success: 'false' } if params[:url_code].blank?
    @post = Post.find_by_url_code!(params[:url_code])
    return destroy if current_user.like? @post
    Favorite.create(:user_id => current_user.id, :url_code => @post.url_code)
    render :json => { success: 'add', count: @post.favoriters.count }
  end

  def destroy
    Favorite.where(url_code: @post.url_code, user_id: current_user.id).destroy_all
    render :json => { success: 'del', count: @post.favoriters.count }
  end
end
