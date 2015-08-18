class Admin::PostsController < Admin::BaseController
  load_and_authorize_resource
  before_action :check_posts, only: [:index, :reviewings, :myown, :draft]

  cache_sweeper :post_sweeper, :only => [:update, :do_publish, :undo_publish]

  def index
    @posts = page.call @posts.published.accessible_by(current_ability).order('published_at desc'), params[:page]
  end

  def reviewings
    @posts = page.call @posts.reviewing.accessible_by(current_ability).order('id desc'), params[:page]
  end

  def myown
    @posts = page.call @posts.where(author: current_user).order('id desc'), params[:page]
  end

  def draft
    @posts = page.call @posts.where(author: current_user).drafted.order('id desc'), params[:page]
  end

  def update
    @post.assign_attributes(post_params)
    @post.related_post_url_codes =  @post.get_related_post_url_codes if @post.tag_list_changed?
    @post.user_id = params[:post][:user_id] if can? :change_author, @post
    @post.save
    respond_with @post, location: admin_posts_path
  end

  def publish
    return redirect_to edit_admin_post_url(@post) if @post.published?
  end

  def edit
    return redirect_to publish_admin_post_path(@post) unless @post.published?
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
    @post.assign_attributes(post_params)
    return respond_with(@post) { |f| f.html { render :publish } } unless @post.valid?
    @post.activate_publish_schedule if params[:operate_type].eql?('publish')
    @post.related_post_url_codes =  @post.get_related_post_url_codes if @post.tag_list_changed?
    @post.save!
    redirect_to reviewings_admin_posts_path, :notice => '操作成功!'
  end

  def undo_publish
    @post.undo_publish
    @post.save!
    redirect_to :back
  end

  def toggle_tag
    tag_name = 'bdnews'
    @post.bdnews? ? @post.tag_list.delete(tag_name) : @post.tag_list << tag_name
    @post.save!
    redirect_to :back
  end

  private

  def post_params
    params.require(:post).permit(
      :column_id, :title,
      :content, :remark,
      :slug, :summary,
      :catch_title,
      :will_publish_at,
      :title_link, :cover, :tag_list,
      :source_type, :source_urls, :close_comment
    )
  end

  def page
    -> (posts, page_num) { posts.includes({ author: :krypton_authentication }, :column, :tags).page page_num }
  end

  def check_posts
    begin
      return @posts = Column.find(params[:column_id]).posts if params[:column_id].present?
      return @posts = User.find(params[:user_id]).posts if params[:user_id].present?
      @info_flow ||= InfoFlow.find_by_name InfoFlow::DEFAULT_INFOFLOW
      @posts = Post.where(:column_id => @info_flow.columns.map(&:id))
    rescue
      return Post
    end
  end
end
