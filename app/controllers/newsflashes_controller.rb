class NewsflashesController < ApplicationController
  def index
    @newsflashes = Newsflash.by_day("#{params[:year]}-#{params[:month]}-#{params[:day]}").order('created_at asc')
    @posts_today_lastest = Post.today_lastest
  end

  def show
  end
end
