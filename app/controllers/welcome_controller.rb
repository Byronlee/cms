class WelcomeController < ApplicationController
  authorize_object :welcome

  def index
    return cache_index if (params[:page].blank? || params[:page].to_i == 1) && !paginate_by_id_request?
    info_flow = InfoFlow.find_by_name InfoFlow::DEFAULT_INFOFLOW

    posts_with_ads = info_flow.posts_with_ads(page: params[:page], page_direction: params[:d], boundary_post_url_code: params[:b_url_code], ads_required: false, newsflash_required: true)

    @posts_with_ads = posts_with_ads[:posts]
    @total_count = posts_with_ads[:total_count]
    @first_url_code = posts_with_ads[:first_url_code]
    @last_url_code = posts_with_ads[:last_url_code]

    render_template
  end

  def cache_index
    flow_data = CacheClient.instance.info_flow
    cache_data = flow_data.blank? ? {} : JSON.parse(flow_data)
    @posts_with_ads = cache_data['posts']
    @first_url_code = cache_data['first_url_code']
    @last_url_code = cache_data['last_url_code']

    render_template
  end

  def changes
    change_content = File.read(File.expand_path('../../../doc/changes.md', __FILE__))
    @changes = GitHub::Markdown.render_gfm(change_content).html_safe
  end

  def site_map
    info_flow = InfoFlow.find_by_name InfoFlow::DEFAULT_INFOFLOW
    @posts = info_flow.posts
    @authors = User.recent_editor
    @columns = Column.headers
    @newsflashs = Newsflash.recent
  end

  def site_map2
    @tags = ActsAsTaggableOn::Tag.all.order('taggings_count desc')
  end

  private

  def paginate_by_id_request?
    params[:d].present? && params[:b_url_code].present?
  end

  def render_template
     respond_to do |format|
      format.json do
        render json: {
          :total_count => @total_count,
          :first_url_code => @first_url_code,
          :last_url_code => @last_url_code,
          :posts => @posts_with_ads.select{|item| item['position'] == nil && item["type"] != 'seperate'}
        }
      end
      format.all do
        if request.xhr?
          render 'welcome/_info_flow_items.html', locals: {
            :posts_with_ads => @posts_with_ads,
            :first_url_code => @first_url_code,
            :last_url_code => @last_url_code
          }, layout: false
        else
          render 'index.html'
        end
      end
    end
  end
end
