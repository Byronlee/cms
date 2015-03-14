class WelcomeController < ApplicationController
  authorize_object :welcome

  def index
    flow_name = params[:info_flow_name] || '主站'
    flow_data = Redis::HashKey.new('info_flow')[flow_name]
    @posts_with_ads = flow_data.nil? ? {} : JSON.parse(Redis::HashKey.new('info_flow')[flow_name])
  end
end
