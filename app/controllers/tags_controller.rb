class TagsController < ApplicationController
  def show
    @tag = params[:tag]
    @posts = Post.published
      .tagged_with(params[:tag])
      .order('published_at desc')
      .includes(:column, author:[:krypton_authentication])
      .page(params[:page]).per(15)

    @weekly_hot_posts = Post.by_week.tagged_with(params[:tag]).order('views_count desc').limit 15
  end
end
