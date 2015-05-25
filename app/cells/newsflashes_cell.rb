class NewsflashesCell < Cell::Rails
  helper ApplicationHelper

  def index(args = {})
    @newsflashes = Newsflash.tagged_with('_newsflash')

    b_normal_newsflash = Newsflash.find(params[:b_normal_id]) if args[:b_normal_id]
    b_top_newsflash = Newsflash.find(params[:b_top_id]) if args[:b_top_id]
    if b_normal_newsflash && args[:d] == 'next'
      unless b_top_newsflash
        @newsflashes = @newsflashes.where("newsflashes.created_at < ?", b_normal_newsflash.created_at).where(is_top: :false)
      else
        @newsflashes = @newsflashes.where("case when is_top = true then newsflashes.toped_at < ? else newsflashes.created_at < ? end", b_top_newsflash.toped_at, b_normal_newsflash.created_at)
      end
    end

    @newsflashes = @newsflashes.top_recent.limit 5
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
