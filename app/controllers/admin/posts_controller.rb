class Admin::PostsController < Admin::BaseController
  load_and_authorize_resource

  def index
    @posts = Post.order('updated_at desc').includes(:author, :column).page params[:page]
  end

  def update
    @post.update(post_params)
    respond_with @post, location: admin_posts_path
  end

  def create
    @post.author = current_user
    @post.save
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
