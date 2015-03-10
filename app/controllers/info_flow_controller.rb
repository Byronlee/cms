class InfoFlowController < ApplicationController
  def lastest
    flow_name = params[:info_flow_name] || '主站'
    info_flow = InfoFlow.find_by_name flow_name
    @posts_with_ads, @total_count, @prev_page, @next_page = info_flow.posts_with_ads(params[:page] || 1)
  end
end
