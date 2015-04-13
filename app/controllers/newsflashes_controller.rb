class NewsflashesController < ApplicationController
  def index
    @newsflashes = Newsflash.by_day('2015-03-10').order('created_at asc')
  end

  def show
  end
end
