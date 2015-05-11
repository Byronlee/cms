class Asynces::PostsController < ApplicationController
  def hots
    posts_data =  CacheClient.instance.hot_posts
    @posts = posts_data.present? ? JSON.parse(posts_data) : []
    render '_hots', :layout => false
  end

  def today
    posts_data = CacheClient.instance.today_lastest
    @posts = { count: 0, posts: [] }
    return render 'today', :layout => false if posts_data.blank?
    hash_data = JSON.parse(posts_data)[0]
    @posts = { count: hash_data['posts_count'], posts: hash_data['posts'] }
    render 'today', :layout => false
  end

  def record_post_manage_session_path
    return if params[:path].blank?
    current_user.update(admin_post_manage_session_path: params[:path])
    render json: { status: true }
  end
end
