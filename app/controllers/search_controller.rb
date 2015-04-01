class SearchController < ApplicationController
  def search
    if params[:q].nil?
      @articles = []
    else
      options={page: 1, per_page: 10}
      @articles = Post.search(params[:q],options)
    end
  end
end
