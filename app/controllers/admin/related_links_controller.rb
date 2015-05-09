class Admin::RelatedLinksController < Admin::BaseController
  load_and_authorize_resource

  def index
    @post = Post.find params[:post_id]
    @related_links = @post.related_links.order("created_at desc").page params[:page]
  end

  def new
    @post = Post.find params[:post_id]
    @related_link = @post.related_links.build
  end

  def edit
    @post = Post.find params[:post_id]
    @related_link = @post.related_links.find params[:id]
  end

  def create
    @post = Post.find params[:post_id]
    @related_link = @post.related_links.build(related_link_params)
    @related_link.save
    redirect_to admin_post_related_links_path
  end

  def update
    @related_link.update(related_link_params)
    redirect_to admin_post_related_links_path
  end

  private

  def related_link_params
    params.require(:related_link).permit(:url, :title, :link_type, :image, :description) if params[:related_link]
  end
end
