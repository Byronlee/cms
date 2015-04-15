class TagsController < ApplicationController
  def show
    @tag = params[:tag]
    @posts = Post.published.tagged_with(params[:tag]).order('published_at desc')
    @posts = @posts.includes(:column, author: [:krypton_authentication])
    @posts = @posts.page(params[:page]).per(15)
    raise ActiveRecord::RecordNotFound if @posts.blank?
  end
end
