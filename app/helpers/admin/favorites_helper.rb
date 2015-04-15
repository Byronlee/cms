module Admin::FavoritesHelper
  def display_time_ago(raw_time)
    timeline = Time.parse('2015-03-28 23:59:59.000000')
    if raw_time > timeline
      raw "<span title='#{raw_time}' data-toggle='tooltip'>#{time_ago_in_words raw_time}</span>"
    else
      raw "<span title='抱歉，您早期的收藏未记录时间' data-toggle='tooltip' style='color:#f00;'>-</span>"
    end
  end
end
