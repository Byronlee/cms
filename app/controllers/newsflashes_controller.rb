class NewsflashesController < ApplicationController
  def index
    @newsflashes = Newsflash.by_day("#{params[:year]}-#{params[:month]}-#{params[:day]}").order('created_at asc')
    @newsflashes.map(&:increase_views_count)
  end

  def show
    @newsflash = Newsflash.find params[:id]
    @newsflash.increase_views_count
  end
end
