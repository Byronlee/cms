class Asynces::PostsController < ApplicationController
  load_resource only: :comments_count

  def hots
    posts_data =  CacheClient.instance.hot_posts
    @posts = posts_data.present? ? JSON.parse(posts_data) : []
    render '_hots', :layout => false
  end

  def comments_count
    render :json => @post.comments_count
  end

  def today
    posts_data = CacheClient.instance.today_lastest
    @posts = { count: 0, posts: [] }
    return render 'today', :layout => false if posts_data.blank?
    hash_data = JSON.parse(posts_data)[0]
    @posts = { count: hash_data['posts_count'], posts: hash_data['posts'] }
    render 'today', :layout => false
  end
end
