class SearchController < ApplicationController
  def search
    if params[:q] && (search = Post.search(params)).count > 0
      @posts = Post.find_and_order_by_ids(search)
      @last_page = ((search.records.total - 1) / 30).ceil + 1
    else
      @posts = Post.none
      @last_page = 0
    end
    @posts_today_lastest = Post.today_lastest
  end
end
