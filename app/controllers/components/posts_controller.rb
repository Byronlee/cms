class Components::PostsController < ApplicationController
  def today_lastest
    @posts = Redis::HashKey.new('posts')['today_lastest']
    render :json => @posts
  end

  def hot_posts
    @posts = Redis::HashKey.new('posts')['hot_posts']
    render :json => @posts
  end

  def new_posts
    @posts = Redis::HashKey.new('posts')['new_posts']
    render :json => @posts
  end

  def weekly_hot
    @posts = Redis::HashKey.new('posts')['weekly_hot']
    render :json => @posts
  end
end
