class Admin::HeadLinesController < Admin::BaseController
  load_and_authorize_resource

  def index
    @head_lines = HeadLine.order('updated_at desc').page params[:page]
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

  private

  def head_line_params
    params.require(:head_line).permit(:url, :order_num, :title, :post_type, :image) if params[:head_line]
  end
end
