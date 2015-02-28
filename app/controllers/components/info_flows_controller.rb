class Components::InfoFlowsController < ApplicationController
  def index
    main_site_info_flow = InfoFlow.find_by_name('主站')
    @posts_with_ads, @total_count = main_site_info_flow.posts_with_ads(params[:page] || 1)
    render :json => { :totle_count => @total_count, :posts_with_ads => @posts_with_ads }
  end
end
