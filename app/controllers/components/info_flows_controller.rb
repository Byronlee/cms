class Components::InfoFlowsController < ApplicationController
  def index
    flow_name = params[:info_flow_name] || '主站'
    @posts_with_ads = Redis::HashKey.new('info_flow')[flow_name]
    render :json => @posts_with_ads
  end
end
