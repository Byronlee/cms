module SearchHelper
  def last_page(search)
    ((search.records.total - 1) / 30).ceil + 1
  end
end
