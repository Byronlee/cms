class Admin::MobileAdsController < Admin::BaseController
  load_and_authorize_resource

  def index
    @mobile_ads = MobileAd.order(ad_position: :asc).page params[:page]
  end

  def show
    respond_with(@mobile_ad)
  end

  def new
    @mobile_ad = MobileAd.new
  end

  def edit
  end

  def create
    @mobile_ad = MobileAd.new(mobile_ad_params)
    if @mobile_ad.save
      flash[:warn] = '新广告创建成功！'
      redirect_to admin_mobile_ads_path(@mobile_ad)
    else
      flash[:warn] = '广告表单数据不完整'
      render :new
    end

  end

  def update
    @mobile_ad.update(mobile_ad_params)
    respond_with(@mobile_ad)
  end

  def destroy
    @mobile_ad.destroy

  end

  private
    def set_mobile_ad
      @mobile_ad = MobileAd.find(params[:id])
    end

    def mobile_ad_params
      params.require(:mobile_ad).permit(:ad_title, :ad_url, :ad_img_url, :ad_position, :ad_enable_time, :ad_end_time, :ad_summary, :api_count, :click_count)
    end
end
