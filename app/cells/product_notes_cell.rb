class ProductNotesCell < Cell::Rails
  helper PnoteHelper

  def index(args = {})
    @pdnotes = Newsflash.tagged_with('_pdnote')
    # TODO 重构
    b_pdnote = Newsflash.find(params[:b_id]) if args[:b_id]
    if b_pdnote && args[:d] == 'next'
      @pdnotes = @pdnotes.where("newsflashes.created_at < ?", b_pdnote.created_at)
    elsif b_pdnote && args[:d] == 'prev'
      @pdnotes = @pdnotes.where("newsflashes.created_at > ?", b_newsflash.created_at)
    end

    @pdnotes = @pdnotes.recent.limit 10
    render
  end
end
