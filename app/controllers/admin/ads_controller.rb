class Admin::AdsController < Admin::BaseController
  load_and_authorize_resource

  def index
    @ads = Ad.order('position asc').page params[:page]
  end

  def update
    @ad.update(ad_params)
    respond_with @ad, location: admin_ads_path
  end

  def create
    @ad.save
    respond_with @ad, location: admin_ads_path
  end

  def destroy
    @ad.destroy
    redirect_to :back
  end

  private

  def ad_params
    params.require(:ad).permit(:position, :content) if params[:ad]
  end
end
