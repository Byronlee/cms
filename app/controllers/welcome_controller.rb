class WelcomeController < ApplicationController
  authorize_object :welcome

  def index
    flow_name = params[:info_flow_name] || '主站'
    flow_data = Redis::HashKey.new('info_flow')[flow_name]
    @posts_with_ads = flow_data.nil? ? {} : JSON.parse(Redis::HashKey.new('info_flow')[flow_name])

    head_lines_data = Redis::HashKey.new('head_lines')['list']
    @head_lines = head_lines_data.present? ? JSON.parse(Redis::HashKey.new('head_lines')['list']) : []
  end
end
