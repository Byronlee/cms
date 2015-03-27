class Admin::FavoritesController < Admin::BaseController
  load_and_authorize_resource

  def index
    @favorites = current_user.favorites.order('id desc').includes({post: :column}).page params[:page]
  end

  def destroy
    @favorite.destroy
    redirect_to :back
  end
end
