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
end