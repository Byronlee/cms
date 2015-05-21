class ProductNoteCell < Cell::Rails
  helper ApplicationHelper

  def index
    @pdnotes = Newsflash.tagged_with('_pdnote').order(created_at: :desc).limit 5
    render
  end
end
