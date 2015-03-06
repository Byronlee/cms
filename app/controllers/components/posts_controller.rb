class Components::PostsController < ApplicationController
  def today_lastest
    @posts = Redis::HashKey.new('posts')['today_lastest']
    render :json => @posts
  end

  def hot_posts
    @posts = Redis::HashKey.new('posts')['hot_posts']
    render :json => @posts
  end
end
