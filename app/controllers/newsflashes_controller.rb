class NewsflashesController < ApplicationController
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
    b_pdnote = Newsflash.find(params[:b_id]) if params[:b_id]
    @pdnotes = Newsflash.tagged_with('_pdnote')
    if b_pdnote && params[:d] == 'next'
      @pdnotes = @pdnotes.where("newsflashes.created_at < ?", b_pdnote.created_at)
    elsif b_pdnote && params[:d] == 'prev'
      @pdnotes = @pdnotes.where("newsflashes.created_at > ?", b_newsflash.created_at)
    end
    @pdnotes = @pdnotes.recent.limit 5

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
    b_newsflash = Newsflash.find(params[:b_id]) if params[:b_id]
    @newsflashes = Newsflash.tagged_with('_newsflash')
    if b_newsflash && params[:d] == 'next'
      @newsflashes = @newsflashes.where("newsflashes.created_at < ?", b_newsflash.created_at)
    elsif b_newsflash && params[:d] == 'prev'
      @newsflashes = @newsflashes.where("newsflashes.created_at > ?", b_newsflash.created_at)
    end

    @newsflashes = @newsflashes.recent.limit 30
    @news_day = @newsflashes.first.created_at.to_date if @newsflashes.first

    respond_to do |format|
      format.html do
        if request.xhr?
          render 'newsflashes/_newsflashes_list', locals: { :pdnotes => @pdnotes }, layout: false
        else
          columns_data = CacheClient.instance.columns_header
          @columns = JSON.parse(columns_data.present? ? columns_data : '{}')
        end
      end
    end
  end

  private

  def increase_views_count
    @newsflash = Newsflash.find params[:id]
    @newsflash.increase_views_count
  end
end
