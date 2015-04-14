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
end
