class WelcomeController < ApplicationController
  authorize_object :welcome

  def index
    flow_name = params[:info_flow_name] || '主站'
    if(params[:page].blank? || params[:page] == 1)
      flow_data = Redis::HashKey.new('info_flow')[flow_name]
      @posts_with_ads = flow_data.nil? ? {} : JSON.parse(Redis::HashKey.new('info_flow')[flow_name])
      @posts_with_ads = @posts_with_ads["posts_with_ads"]
      @prev_page = nil
      @next_page = 2
    else
      info_flow = InfoFlow.find_by_name flow_name
      @posts_with_ads, @total_count, @prev_page, @next_page = info_flow.posts_with_ads(params[:page] || 1)
    end

    head_lines_data = Redis::HashKey.new('head_lines')['list']
    @head_lines = head_lines_data.present? ? JSON.parse(Redis::HashKey.new('head_lines')['list']) : []
  end

  def changes
    change_content = File.read(File.expand_path('../../../doc/changes.md', __FILE__))
    @changes = GitHub::Markdown.render_gfm(change_content).html_safe
  end
end
