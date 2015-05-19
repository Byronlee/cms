class TagsController < ApplicationController
  def show
    @tag = params[:tag]
    @posts = Post.published.tagged_with(params[:tag]).order('published_at desc')
    @posts = @posts.includes(:column, author: [:krypton_authentication])
    @posts = Post.paginate(@posts, params)

    raise ActiveRecord::RecordNotFound if @posts.blank?

    respond_to do |format|
      format.html do
        if request.xhr?
          render 'tags/_list', locals: { :posts => @posts }, layout: false 
        end
      end
      format.json do 
        render json: Post.posts_to_json(@posts)
      end
    end

  end
end
