class NewsflashesController < ApplicationController
  authorize_resource only: [:toggle_tag]
  before_filter :increase_views_count, only: [:show, :touch_view]
  skip_before_filter :verify_authenticity_token, if: Proc.new{|c| c.request.xhr?}

  def index
    @newsflashes = Newsflash.by_day("#{params[:year]}-#{params[:month]}-#{params[:day]}").order('created_at asc').includes({ author: :krypton_authentication }, :column)
    @newsflashes.map(&:increase_views_count)
  end

  def show
  end

  def feed
    @ptype = params[:ptype].eql?('_pdnote') ? "ProDuctNote | 36氪" : "快讯 | 36氪"
    @feeds = Newsflash.includes({ author: :krypton_authentication }, :tags).tagged_with(params[:ptype]).order('created_at desc').limit(30)
  end

  def touch_view
    render json: {:result => "success"}.to_json
  end

  def touch_views
    Newsflash.transaction do
      Newsflash.where(id: params[:ids]).map(&:increase_views_count)
    end

    render json: {:result => "success"}.to_json
  end

  def product_notes
    @pdnotes = Newsflash.product_notes
    @pdnotes, tmp = Newsflash.paginate(@pdnotes, params.merge({per_page: 5}))

    respond_to do |format|
      format.html do
        if request.xhr?
          render 'newsflashes/_product_notes_list', locals: { :pdnotes => @pdnotes }, layout: false
        else
          columns_data = CacheClient.instance.columns_header
          @columns = JSON.parse(columns_data.present? ? columns_data : '{}')
        end
      end
    end
  end

  def newsflashes
    @newsflashes = Newsflash.newsflashes
    @column = Column.find_by_slug(params[:column_slug]) if params[:column_slug]
    @newsflashes = @newsflashes.where("column_id = ? ", @column.id) if @column.present?
    @newsflashes = @newsflashes.tagged_with(params[:tag]) if params[:tag]
    @newsflashes = @newsflashes.pins if params[:pin]
    @newsflashes, @b_newsflash = Newsflash.paginate(@newsflashes, params)

    respond_to do |format|
      format.html do
        if request.xhr?
          if params[:d] == 'prev'
            @news_day = @newsflashes.first.created_at.to_date if params[:d] != 'prev' && @newsflashes.first
            render 'newsflashes/_prev_list', layout: false
          elsif params[:d] == 'next'
            @news_day = @newsflashes.first.created_at.to_date if @newsflashes.first
            render 'newsflashes/_newsflashes_list', layout: false
          end
        else
          columns_data = CacheClient.instance.columns_header
          @columns = JSON.parse(columns_data.present? ? columns_data : '{}')
        end
      end
    end
  end

  def search
    params[:q] = URI.unescape(params[:q]).gsub('/','') unless params[:q].blank?
    if params[:q].blank?
      @message = '搜索关键词不能为空'
      @newsflashes = Newsflash.none
    elsif params[:q].length > Settings.elasticsearch.query.max_length
      @message = '搜索关键词过长'
      @newsflashes = Newsflash.none
    else
      @newsflashes = Newsflash.search(params)
    end

    respond_to do |format|
      format.html do
        if request.xhr?
          @news_day = @newsflashes.results.first.created_at.to_date if @newsflashes.results.first
          render 'newsflashes/_search_list', layout: false
        else
          columns_data = CacheClient.instance.columns_header
          @columns = JSON.parse(columns_data.present? ? columns_data : '{}')
        end
      end
    end
  end

  def toggle_tag
    @newsflash = Newsflash.find(params[:newsflash_id])
    tag_name = params[:tag_name]
    @newsflash.tag_list.include?(tag_name) ? @newsflash.tag_list.delete(tag_name) : @newsflash.tag_list << tag_name
    @newsflash.save!
    render text: params[:tag_name]
  end

  def news_corp_feed
    if Settings.coop_newsflashes_rss.include?(params[:coop])
      @news = Newsflash.newsflashes.recent.limit(20)
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def news_corp_news
    @new = Newsflash.newsflashes.find_by_id!(params[:id])
    render "news_corp_news", layout: false
  end

  private

  def increase_views_count
    @newsflash = Newsflash.find params[:id]
    @newsflash.increase_views_count
  end
end
