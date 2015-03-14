class Admin::PostsController < Admin::BaseController
  load_and_authorize_resource

  def index
    if(params[:column_id] && column = Column.find(params[:column_id]) )
      @posts = column.posts.published.order('updated_at desc').includes(:author, :column).page params[:page]
    else
      @posts = Post.published.order('updated_at desc').includes(:author, :column).page params[:page]
    end
  end

  def reviewings
    if(params[:column_id] && column = Column.find(params[:column_id]))
      @posts = column.posts.reviewing.order('updated_at desc').includes(:author, :column).page params[:page]
    else
      @posts = Post.reviewing.order('updated_at desc').includes(:author, :column).page params[:page]
    end
  end

  def create
    @post.author = current_user
    @post.save
    respond_with @post, location: admin_posts_path
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

  def publish
  end

  def do_publish
    redirect_to reviewings_admin_posts_path, :error => "文章状态不合法，不能发布！" unless @post.may_publish?
    @post.publish
    if @post.save
      redirect_to reviewings_admin_posts_path, :notice => "文章发布成功"
    else
      render :publish
    end
  end

  private

  def post_params
    params.require(:post).permit(:column_id, :title, :content, :slug, :summary, :title_link, :cover, :tag_list) if params[:post]
  end
end
