
class Admin::PostsController < Admin::BaseController
  load_and_authorize_resource

  def index
    @posts = Column.find(params[:column_id]).posts rescue Post
    @posts = @posts.published.accessible_by(current_ability).order('published_at desc').includes({ author: :krypton_authentication }, :column).page params[:page]
  end

  def column
    @column = Column.find(params[:column_id])
    @posts = @column.posts.published.accessible_by(current_ability).order('published_at desc').includes({ author: :krypton_authentication }, :column).page params[:page]
    render 'column'
  end

  def reviewings
    @posts = Column.find(params[:column_id]).posts rescue Post
    @posts = @posts.reviewing.accessible_by(current_ability).order('id desc').includes({ author: :krypton_authentication }, :column).page params[:page]
  end

  def myown
    @posts = Column.find(params[:column_id]).posts rescue Post
    @posts = @posts.where(author: current_user).order('id desc').includes({ author: :krypton_authentication }, :column).page params[:page]
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

  def do_publish
    if params[:operate_type] == 'publish'
      redirect_to reviewings_admin_posts_path, :notice => '文章状态不合法，不能发布！' unless @post.may_publish?
      @post.publish
      success_msg = '文章发布成功'
    else
      success_msg = '文章保存成功'
    end
    if @post.update(post_params)
      redirect_to reviewings_admin_posts_path, :notice => success_msg
    else
      render :publish
    end
  end

  def undo_publish
    if @post.may_undo_publish?
      @post.undo_publish
      @post.save
    end
    redirect_to :back
  end

  def toggle_tag
    tag_name = 'bdnews'
    if @post.bdnews?
      @post.tag_list.delete(tag_name)
    else
      @post.tag_list << tag_name
    end
    @post.save
    redirect_to :back
  end

  private

  def post_params
    if params[:post]
      params.require(:post).permit(:column_id, :title, :content, :remark,
        :slug, :summary, :title_link, :cover, :tag_list, :user_id)
    end
  end
end
