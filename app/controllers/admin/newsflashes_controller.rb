class Admin::NewsflashesController < Admin::BaseController
  load_and_authorize_resource

  def index
    @newsflashes = @newsflashes.page params[:page]
  end

  def update
    @newsflash.update newsflash_params
    respond_with @newsflash, location: admin_newsflashes_path
  end

  def create
    @newsflash.save
    respond_with @newsflash, location: admin_newsflashes_path
  end

  def newsflash_params
    params.require(:newsflash).permit(:original_input)
  end
end
