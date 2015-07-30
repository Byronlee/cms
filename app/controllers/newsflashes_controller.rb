class NewsflashesController < ApplicationController
  before_filter :increase_views_count, only: [:show, :touch_view]

  def index
    @newsflashes = Newsflash.by_day("#{params[:year]}-#{params[:month]}-#{params[:day]}").order('created_at asc')
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

  private

  def increase_views_count
    @newsflash = Newsflash.find params[:id]
    @newsflash.increase_views_count
  end
end
