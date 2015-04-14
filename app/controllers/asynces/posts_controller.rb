class Asynces::PostsController < ApplicationController
  def hots
    posts_data = Redis::HashKey.new('posts')['hot_posts']
    @posts = posts_data.present? ? JSON.parse(posts_data) : []
    render '_hots', :layout => false
  end
end
