class SearchController < ApplicationController
  def search
    @posts = Post.search(params)
  end
end
