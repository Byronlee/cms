class TagsController < ApplicationController
  def show
    @tag = params[:tag]
    @posts = Post.tagged_with(params[:tag])
      .order('created_at desc')
      .page(params[:page]).per(15)
  end
end
