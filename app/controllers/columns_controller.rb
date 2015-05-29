class ColumnsController < ApplicationController
  def show
    @column = Column.find_by_slug!(params[:slug])
    @posts = @column.posts.published.recent
    @posts = @posts.includes(:column, author: [:krypton_authentication])
    @posts = Post.paginate(@posts, params)

    respond_to do |format|
      format.html do
        if request.xhr?
          render 'columns/_list', locals: { :posts => @posts }, layout: false 
        else
          columns_data = CacheClient.instance.columns_header
          @columns = JSON.parse(columns_data.present? ? columns_data : '{}')
        end
      end
      format.json do 
        render json: Post.posts_to_json(@posts)
      end
    end
  end
end
