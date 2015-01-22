class Admin::PostsController < Admin::BaseController

  def index
  	@posts = Post.includes(:author, :column).page params[:page]
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
  end

  def destroy
  	@post.destroy
    redirect_to :back
  end

  private

  def post_params
    params.require(:post).permit(:column_id, :title, :content, :slug, :summary, :title_link) if params[:post]
  end

end
