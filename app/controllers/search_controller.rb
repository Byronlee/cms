class SearchController < ApplicationController
  def search
    if params[:q]
      options={page: 1, per_page: 10}
      @articles = Post.search(params[:q],options)
    else
      @articles = []
    end
  end
end
