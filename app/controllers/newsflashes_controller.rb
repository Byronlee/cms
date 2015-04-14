class NewsflashesController < ApplicationController
  def index
    @newsflashes = Newsflash.by_day("#{params[:year]}-#{params[:month]}-#{params[:day]}").order('created_at asc')
    @posts_today_lastest = Post.today_lastest
  end

  def show
    newsflash = Newsflash.find params[:id]
    date = newsflash.created_at
    redirect_to newsflashes_of_day_path(year: date.year, month: date.month, day: date.day, anchor: newsflash.id)
  end
end
