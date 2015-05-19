class WelcomeController < ApplicationController
  authorize_object :welcome

  def index
    return cache_index if (params[:page].blank? || params[:page].to_i == 1) && !api_request?
    info_flow = InfoFlow.find_by_name InfoFlow::DEFAULT_INFOFLOW
    page_direction = params[:d]
    boundary_post_url_code = params[:b_url_code]
    @posts_with_ads, @total_count, @prev_page, @next_page, @min_url_code, @max_url_code = info_flow.posts_with_ads(params[:page], page_direction, boundary_post_url_code)

    respond_to do |format|
      format.html do
        if api_request?
          render 'welcome/_info_flows', locals: {
            :posts_with_ads => @posts_with_ads, 
            :prev_page => @prev_page, 
            :next_page => @next_page
          }, layout: false 
        end
      end
      format.json do 
        render json: { 
          :total_count => @total_count,
          :min_url_code => @min_url_code,
          :max_url_code => @max_url_code,
          :posts => @posts_with_ads }
      end
    end
  end

  def cache_index
    flow_data = CacheClient.instance.info_flow
    cache_data = flow_data.blank? ? {} : JSON.parse(flow_data)
    @posts_with_ads = cache_data['posts_with_ads']
    @prev_page, @next_page = nil, 2
    @max_url_code = cache_data['max_url_code']
    @min_url_code = cache_data['min_url_code']
    
    respond_to do |format|
      format.html{ render :index }
      format.json do 
        render json: { 
          :total_count => @total_count,
          :min_url_code => @min_url_code,
          :max_url_code => @max_url_code,
          :posts_with_ads => @posts_with_ads }
      end
    end
  end

  def changes
    change_content = File.read(File.expand_path('../../../doc/changes.md', __FILE__))
    @changes = GitHub::Markdown.render_gfm(change_content).html_safe
  end

  def site_map
    info_flow = InfoFlow.find_by_name InfoFlow::DEFAULT_INFOFLOW
    @posts = info_flow.posts
  end

  private

  def api_request?
    params[:d].present? && params[:b_url_code].present?
  end
end
