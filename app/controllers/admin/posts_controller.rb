class Admin::PostsController < Admin::BaseController
  load_and_authorize_resource

  def index
    if(params[:column_id] and column = Column.find(params[:column_id]))
      @posts = column.posts.order('updated_at desc').includes(:author, :column).page params[:page]
    else
      @posts = Post.order('updated_at desc').includes(:author, :column).page params[:page]
    end
  end

  def update
    @post.update(post_params)
    respond_with @post, location: admin_posts_path
  end

  def show
    @post = Post.includes(:author, :column).find(params[:id])
    @host = request.host_with_port
  end

  def destroy
    @post.destroy
    redirect_to :back
  end

  private

  def post_params
    params.require(:post).permit(:column_id, :title, :content, :slug, :summary, :title_link, :cover) if params[:post]
  end
end
