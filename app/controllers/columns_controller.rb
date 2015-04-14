class ColumnsController < ApplicationController
  def show
    @column = Column.find_by_slug!(params[:slug])
    @posts = @column.posts.published.order('published_at desc')
    @posts = @posts.includes(:column, author: [:krypton_authentication])
    @posts = @posts.page(params[:page]).per(15)
  end
end
