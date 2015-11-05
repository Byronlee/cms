module NewsflashHelper
  def archive_title(params)
    title = params[:year]
    title += "-#{params[:month]}" if params[:month]
    title += "-#{params[:day]}" if params[:day]
    title
  end

  def share_back_url(newsflash)
    return "#{newsflashes_list_url}?share_id=#{newsflash.id}"
  end

  def wrap_period_content(newsflash)
    if newsflash.present?
      sting = /(.*?[。|？|！|\.])(.*)/im.match newsflash
      new_string = sting.present? ? "<div>#{sting[1]}</div><div>#{sting[2] if sting[2]}</div>" : newsflash
    else
      new_string = '<div>更多内容请查看https://36kr.com</div>'
    end
    return new_string
  end
end