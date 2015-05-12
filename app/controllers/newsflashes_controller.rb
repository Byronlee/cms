class NewsflashesController < ApplicationController
  def index
    @newsflashes = Newsflash.by_day("#{params[:year]}-#{params[:month]}-#{params[:day]}").order('created_at asc')
    @newsflashes.map(&:increase_views_count)
  end

  def show
    newsflash = Newsflash.find params[:id]
    date = newsflash.created_at
    redirect_to newsflashes_of_day_path(year: date.year, month: date.month, day: date.day, anchor: newsflash.id)
  end
end
