class NewsflashesListCell < Cell::Rails
  helper ApplicationHelper

  def header(args)
    @columns = args[:columns]
    @column = args[:column]
    @nf_count = args[:nf_count]
    render
  end

  cache :tags, :expires_in => 1.minutes do |arg|
    [:newsflashes_list, :tags, arg[:from]]
  end

  def tags(arg)
    @tags = Newsflash.newsflashes.where(created_at: 1.week.ago..DateTime.now).tag_counts_on(:tags).order(taggings_count: :desc).limit(arg[:num])
    @tags = @tags.to_a.delete_if{|tag| tag.name == '_newsflash'}
    render template: '/newsflashes_list/' + arg[:from].to_s
  end

  def hot
    @newsflashes = Newsflash.newsflashes.where(created_at: 1.week.ago..DateTime.now).order(views_count: :desc).limit 10
    render
  end
end
