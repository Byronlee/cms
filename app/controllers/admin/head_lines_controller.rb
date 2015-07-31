class Admin::HeadLinesController < Admin::BaseController
  load_and_authorize_resource

  def index
    @head_lines = @head_lines.published.recent.weight.related.page params[:page]
  end

  def archives
    @head_lines = @head_lines.archived.recent.related.page params[:page]
  end

  def update
    @head_line.update(head_line_params)
    respond_with @head_line, location: admin_head_lines_path
  end

  def new
    @head_line.url = params[:url]
  end

  def create
    @head_line.user = current_user
    @head_line.save
    respond_with @head_line, location: admin_head_lines_path
  end

  def destroy
    @head_line.destroy
    redirect_to :back
  end

  def archive
    @head_line.archive
    @head_line.save
    redirect_to :back
  end

  def publish
    @head_line.publish
    @head_line.save
    redirect_to :back
  end

  private

  def head_line_params
    params.require(:head_line).permit(:url, :order_num, :title, :post_type, :image, :url_code, :section, :display_position, :sumarry) if params[:head_line]
  end
end
