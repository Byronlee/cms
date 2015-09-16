class NewsflashesListCell < Cell::Rails
  helper ApplicationHelper

  def header(args)
    @columns = args[:columns]
    render
  end

  def tags
    render
  end

  def hot
    render
  end
end
