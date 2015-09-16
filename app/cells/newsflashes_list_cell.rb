class NewsflashesListCell < Cell::Rails
  helper ApplicationHelper

  def header(args)
    @columns = args[:columns]
    render
  end

  def tags(arg)
    @tags = Newsflash.pnews.where(created_at: 1.week.ago..DateTime.now).tag_counts_on(:tags).order(taggings_count: :desc).limit(arg[:num])
    render
  end

  def hot
    @newsflashes = Newsflash.pnews.where(created_at: 1.week.ago..DateTime.now).order(created_at: :desc).limit 10
    render
  end
end
