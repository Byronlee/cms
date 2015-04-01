class SearchController < ApplicationController
  def search
    if params[:q]
      @posts = Post.search(params)
    else
      @posts = Post.none
    end
    @column = nil
    @posts_today_lastest = Post.today_lastest
  end
end
