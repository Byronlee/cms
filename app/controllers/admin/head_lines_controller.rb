class Admin::HeadLinesController < Admin::BaseController
  load_and_authorize_resource

  def index
    @head_lines = HeadLine.published.order('updated_at desc').includes(user: :krypton_authentication).page params[:page]
  end

  def archives
    @head_lines = HeadLine.archived.order('updated_at desc').includes(user: :krypton_authentication).page params[:page]
  end

  def update
    @head_line.update(head_line_params)
    respond_with @head_line, location: admin_head_lines_path
  end

  def new
    @head_line = HeadLine.new(:url => params[:url])
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
    if @head_line.may_archive?
      @head_line.archive
      @head_line.save
    end
    redirect_to :back
  end

  def publish
    if @head_line.may_publish?
      @head_line.publish
      @head_line.save
    end
    redirect_to :back
  end

  private

  def head_line_params
    params.require(:head_line).permit(:url, :order_num, :title, :post_type, :image, :url_code) if params[:head_line]
  end
end
