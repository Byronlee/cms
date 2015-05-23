class NewsflashesCell < Cell::Rails
  helper ApplicationHelper

  def index
    @newsflashes = Newsflash.tagged_with('_newsflash').order(:toped_at, created_at: :desc).limit 20
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
