class SearchController < ApplicationController
  def search
    params[:page] ||= 1
    if params[:q] && (@search = Post.search(params)).count > 0
      @posts = Post.find_and_order_by_ids(@search)
    else
      @posts = Post.none
    end
    @posts_today_lastest = Post.today_lastest
  end
end
