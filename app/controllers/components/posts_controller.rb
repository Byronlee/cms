class Components::PostsController < ApplicationController
  def today_lastest
    @posts = Redis::HashKey.new('posts')['today_lastest']
    render :json => @posts
  end
end
