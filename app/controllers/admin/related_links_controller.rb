class Admin::RelatedLinksController < Admin::BaseController
  load_and_authorize_resource
  before_filter :find_post, except: [:destroy]

  def index
    @related_links = @post.related_links.order("created_at desc").page params[:page]
  end

  def new
    # @related_link = @post.related_links.build
  end

  def edit
    # @related_link = @post.related_links.find params[:id]
  end

  def create
    @related_link = @post.related_links.build(related_link_params)
    @related_link.assign_extras(params[:related_link])
    @related_link.user = current_user
    if @related_link.save
      redirect_to admin_post_related_links_path(@post)
    else
      render :new
    end
  end

  def update
    @related_link.update(related_link_params)
    @related_link.assign_extras(params[:related_link])
    if @related_link.save
      redirect_to admin_post_related_links_path(@post)
    else
      render :edit
    end
  end

  def destroy
    @related_link.destroy
    redirect_to :back
  end

  private

  def related_link_params
    params.require(:related_link).permit(:url, :title, :link_type, :image, :description) if params[:related_link]
  end

  def find_post
    @post = Post.find params[:post_id]
  end
end
