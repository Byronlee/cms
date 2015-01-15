class Admin::PostsController < Admin::BaseController

  def index
  	@posts = Post.all
  end

  def update
  	@post.save
  	respond_with @post, location: admin_posts_path
  end

  def create
  	@post.save
  	respond_with @post, location: admin_posts_path
  end

  def destroy
  	@post.destroy
    redirect_to :back
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :slug, :summary, :title_link) if params[:post]
  end

end
