class ColumnsController < ApplicationController
  def show
    @column = Column.find_by_slug!(params[:slug])
    @posts = @column.posts.published.recent
    @posts = @posts.includes(:column, author: [:krypton_authentication])
    @posts = Post.paginate(@posts, params)
    @posts_with_newsflashes = Post.merger_newsflashes(@column, @posts, params)

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
      format.xml do
        #/api/wx/column.xml?slug=o2o&to_user=toUser&from_user=fromUser&page=1&per_page=5
        render 'columns/column', locals: { :posts => @posts }, layout: false
      end
    end
  end

  def feed
    @column = Column.find_by_slug!(params[:slug])
    @feeds = @column.posts.published.includes({ author: :krypton_authentication }, :column).order('published_at desc').limit(20)
  end
end
