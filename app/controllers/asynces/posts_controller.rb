class Asynces::PostsController < ApplicationController
  def hots
    posts_data =  CacheClient.instance.hot_posts
    @posts = posts_data.present? ? JSON.parse(posts_data) : []
    render '_hots', :layout => false
  end
end
