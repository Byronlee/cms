class Admin::NewsflashesController < Admin::BaseController
  load_and_authorize_resource

  def index
    @newsflashes = @newsflashes.order("created_at desc").includes(author: :krypton_authentication).page params[:page]
  end

  def update
    flash[:notice] = '更新成功' if @newsflash.update newsflash_params
    respond_with @newsflash, location: admin_newsflashes_path
  end

  def create
    @newsflash.author = current_user
    flash[:notice] = '创建成功' if @newsflash.save
    respond_with @newsflash, location: admin_newsflashes_path
  end

  def destroy
    @newsflash.destroy
    redirect_to :back, :notice => '删除成功'
  end

  def set_top
    @newsflash.set_top
    @newsflash.save
    redirect_to :back, :notice => '置顶成功'
  end

  def set_down
    @newsflash.set_top
    @newsflash.save
    redirect_to :back, :notice => '取消置顶成功'
  end

  private
  def newsflash_params
    params.require(:newsflash).permit(:original_input, :tag_list, :newsflash_topic_color_id, :cover)
  end
end
