class Admin::Posts::ColumnsController < Admin::BaseController
  load_and_authorize_resource
  respond_to :json, only: :create

  def index
    @columns = Column.find params[:ids]
    @posts = Post.where.not(column_id: @columns.map(&:id)).published.order('published_at desc').page(params[:page])
      .per(params[:per])
  end

  def create
    @post = Post.find(params[:post_id])
    @column = Column.find(params[:column_id])
    @post.update column_id: @column.id
    if @post.save
      render nothing: true
    else
      render json: { message: @post.errors.full_messages.first }, status: :unprocessable_entity
    end
  end
end
