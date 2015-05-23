class ProductNoteCell < Cell::Rails
  helper ApplicationHelper

  def index
    @pdnotes = Newsflash.tagged_with('_pdnote').order(created_at: :desc).limit 10
    render
  end
end
