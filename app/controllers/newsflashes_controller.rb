class NewsflashesController < ApplicationController
  def index
    @newsflashes = Newsflash.by_day("#{params[:year]}-#{params[:month]}-#{params[:day]}").order('created_at asc')
    @newsflashes.map(&:increase_views_count)
  end

  def show
    @newsflash = Newsflash.find params[:id]
    @newsflash.increase_views_count
  end

  def feed
    @ptype = params[:ptype].eql?('_pdnote') ? "ProDuctNote | 36氪" : "快讯 | 36氪"
    @feeds = Newsflash.includes({ author: :krypton_authentication }, :tags).tagged_with(params[:ptype]).order('created_at desc').limit(30)
  end
end
