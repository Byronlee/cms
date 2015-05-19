class NewsflashesCell < Cell::Rails
  helper ApplicationHelper

  def index
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
