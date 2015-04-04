class SearchController < ApplicationController
  def search
    @posts = Post.search(params)
    @posts_today_lastest = Post.today_lastest
  end
end
