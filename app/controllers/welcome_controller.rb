class WelcomeController < ApplicationController
  authorize_object :welcome

  def index
    return cache_index if params[:page].blank? || params[:page].to_i == 1
    info_flow = InfoFlow.find_by_name InfoFlow::DEFAULT_INFOFLOW
    @posts_with_ads, @total_count, @prev_page, @next_page = info_flow.posts_with_ads(params[:page])
  end

  def cache_index
    flow_data = CacheClient.instance.info_flow
    @posts_with_ads = flow_data.nil? ? {} : JSON.parse(flow_data)
    @posts_with_ads = @posts_with_ads['posts_with_ads']
    @prev_page, @next_page = nil, 2
    render :index
  end

  def archives
    @posts = Post.published.by_year(params[:year])
    @posts = @posts.by_month(params[:month]) if params[:month].present?
    @posts = @posts.by_day("#{params[:year]}-#{params[:month]}-#{params[:day]}") if params[:day].present?
    @posts = @posts.order('published_at desc').page params[:page]
  end

  def changes
    change_content = File.read(File.expand_path('../../../doc/changes.md', __FILE__))
    @changes = GitHub::Markdown.render_gfm(change_content).html_safe
  end

  def site_map
    info_flow = InfoFlow.find_by_name InfoFlow::DEFAULT_INFOFLOW
    @posts = info_flow.posts
  end
end
