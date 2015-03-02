class Components::InfoFlowsController < ApplicationController
  def index
    flow_name = params[:info_flow_name] || '主站'
    # main_site_info_flow = InfoFlow.find_by_name flow_name
    # @posts_with_ads, @total_count = main_site_info_flow.posts_with_ads(params[:page] || 1)
    @posts_with_ads = Redis::HashKey.new('info_flow')[flow_name]
    # render :json => { :totle_count => @total_count, :posts_with_ads => @posts_with_ads }
    render :json => @posts_with_ads
  end
end
