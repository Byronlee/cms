class UsersController < ApplicationController
  load_resource only: :current

  def messages
    return render :text => '', layout: false if params['data'].blank? || params['data']['code'].to_i != 0
    render '_messages', layout: false
  end

  def favorites
    @favorites = Favorite.where(user_id: current_user.id)
    .order(created_at: :desc)
    .page(params[:page]).per(params[:per_page])
  end
end
