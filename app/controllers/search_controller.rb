class SearchController < ApplicationController
  def search
    @posts = Post.search(params)

    respond_to do |format|
      format.html do
        if request.xhr?
          render 'search/_list', locals: { :posts => @posts }, layout: false 
        end
      end
      format.json do 
        render json: Post.posts_to_json(@posts, true)
      end
    end

  end
end
