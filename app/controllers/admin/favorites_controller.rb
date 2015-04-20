class Admin::FavoritesController < Admin::BaseController
  load_and_authorize_resource

  def index
    @favorites = current_user.favorites
    @favorites = @favorites.joins("inner join posts on posts.url_code = favorites.url_code and posts.state = 'published'")
    @favorites = @favorites.order('id desc').includes({ post: [:column, { author: :krypton_authentication }] }, user: :krypton_authentication).page params[:page]
  end

  def destroy
    @favorite.destroy
    redirect_to :back
  end
end
