class ColumnsController < ApplicationController
  def index
  end

  def show
    @column = Column.find_by_slug(params[:slug])
    if @column
      @posts = @column.posts.published
        .order('published_at desc')
        .includes(:column, author:[:krypton_authentication])
        .page(params[:page]).per(15)
      @weekly_hot_posts = @column.posts.by_week.order('views_count desc').limit 15
    else
      @posts = []
      @weekly_hot_posts = []
    end
  end
end
