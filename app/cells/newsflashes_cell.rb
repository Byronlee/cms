class NewsflashesCell < Cell::Rails
  helper ApplicationHelper

  def index(args = {})
    @newsflashes = Newsflash.tagged_with('_newsflash')

    b_newsflash = Newsflash.find(params[:b_id]) if args[:b_id]
    if b_newsflash && args[:d] == 'next'
      @newsflashes = @newsflashes.where("newsflashes.created_at < ?", b_newsflash.created_at)
    elsif b_newsflash && args[:d] == 'prev'
      @newsflashes = @newsflashes.where("newsflashes.created_at > ?", b_newsflash.created_at)
    end

    @newsflashes = @newsflashes.order(:toped_at, created_at: :desc).limit 5
    render
  end

  def header(args)
    @newsflash = args[:newsflash]
    render
  end

  def content(args)
    @newsflashes = args[:newsflashes]
    render
  end

  def tips
    render
  end
end
