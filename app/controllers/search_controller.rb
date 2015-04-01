class SearchController < ApplicationController
  def search
    if params[:q]
      @posts = Post.search(params)
      @last_page = ((@posts.records.total - 1) / 30).ceil + 1
    else
      @posts = Post.none
      @last_page = 0
    end
    @column = nil
    @posts_today_lastest = Post.today_lastest
  end
end
