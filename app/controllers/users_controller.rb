class UsersController < ApplicationController
  load_resource only: :current
  load_resource only: :posts, find_by: :domain, id_param: :user_domain
  load_and_authorize_resource :favorite, through: :current_user, only: :favorites, parent: false
  authorize_resource only: :update_current
  skip_before_action :verify_authenticity_token, only: :update_current

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

  def posts
    @posts = @user.posts.published.includes(:author, :column).recent
    @posts = Post.paginate(@posts, params)

    respond_to do |format|
      format.html do
        if request.xhr?
          render 'users/_list', locals: { :posts => @posts }, layout: false
        end
      end
      format.json do
        render json: Post.posts_to_json(@posts)
      end
    end
  end

  def current
    return if current_user.blank?
  end

  def update_current
    current_user.domain = params[:domain] if params[:domain].present? && current_user.domain.blank?
    current_user.tagline = params[:tagline] if params[:tagline].present?
    current_user.save if current_user.changed?
    render json: {result: 'success'}.to_json
  end
end
