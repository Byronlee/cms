class SearchController < ApplicationController
  def search
    if params[:q]
      options={page: 1, per_page: 10}
      @posts = Post.search(params[:q],options)
    else
      @posts = []
    end
    @column = nil
    @posts_today_lastest = Post.today_lastest
  end
end
