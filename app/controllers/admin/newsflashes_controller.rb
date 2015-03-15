class Admin::NewsflashesController < Admin::BaseController
  load_and_authorize_resource

  def index
    @newsflashes = @newsflashes.page params[:page]
  end

  def update
    @newsflash.update newsflash_params
    respond_with @newsflash, location: admin_newsflashes_path, :info => '更新成功'
  end

  def create
    @newsflash.author = current_user
    @newsflash.save
    respond_with @newsflash, location: admin_newsflashes_path, :info => '创建成功'
  end

  def destroy
    @newsflash.destroy
    redirect_to :back, :info => '删除成功'
  end

  def newsflash_params
    params.require(:newsflash).permit(:original_input, :tag_list, :newsflash_topic_color_id)
  end
end
