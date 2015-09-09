module NewsflashHelper
  def archive_title(params)
    title = params[:year]
    title += "-#{params[:month]}" if params[:month]
    title += "-#{params[:day]}" if params[:day]
    title
  end
end