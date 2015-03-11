class ColumnsController < ApplicationController
  def index
  end

  def show
    @column = Column.find_by_slug(params[:slug])
    if @column
      @posts = @column.posts.order('created_at desc').page(params[:page]).per(15)
    else
      @posts = []
    end
  end
end
