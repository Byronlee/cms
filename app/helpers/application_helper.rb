module ApplicationHelper
  def show_tag_name(tag_name)
    case tag_name
    when 'krweekly'
      '氪周刊'
    else
      tag_name
    end
  end

  def in_wechat?
    !!(request.user_agent =~ /micromessenger/i)
  end

  def portable_device?
    (params[:portable] == "1") or !!(request.user_agent =~ /Mobile|webOS/)
  end

  def post_url(arg, options = {})
    return arg.title_link unless arg.try(:title_link).blank?
    url_code = (arg.class.to_s == 'Fixnum' ? arg : arg.url_code)
    if options[:utm_source].blank?
      post_show_by_url_code_url(url_code)
    else
      post_show_by_url_code_url(url_code, utm_source: options[:utm_source])
    end
  end

  def high_speed_url(raw_url, postfix)
    match = /(http:\/\/.\.36krcnd\.com)(.*)/.match(raw_url)
    return raw_url unless match
    host = "http://#{['a', 'b', 'c', 'd', 'e'][rand(5)]}.36krcnd.com"
    "#{host}#{match[2]}!#{postfix}"
  end

  def smart_time_ago(raw_time, days_distance = 1)
    return raw_time if raw_time.blank?
    if raw_time + days_distance.day < Time.now
      raw "<abbr class=\"timeago\" title=\"#{raw_time}\">#{raw_time.strftime('%Y/%m/%d %H:%M')}</abbr>"
    else
      raw "<time class=\"timeago\" title=\"#{raw_time}\" datetime=\"#{raw_time}\">#{relative_time(raw_time)}</time>"
    end
  end

  def nav_active(local, target)
    local = [] << local unless local.class == Array
    return 'active' if local.include? target.to_sym
  end

  def reviewings_count
    @num ||= Post.reviewing.count
  end

  def body_class(name = nil)
    if name.present?
      content_for(:body_class) { name }
    else
      content_for(:body_class)
    end
  end

  def get_url_domain(url)
    return "" if url.blank?

    url = URI::encode(url)
    URI.parse(url).host.gsub(/www\./i, "")
  rescue
    return ""
  end

  def check_mobile
    request.user_agent =~ /Mobile|webOS/
  end

  def time_local_zone(time)
    return nil if time.blank?
    time.in_time_zone(Rails.configuration.time_zone)
  end

  private

  def relative_time(raw_time)
    time = distance_of_time_in_words_to_now(raw_time)
    time_arr = time.split('')
    time_arr << '前' if time_arr.first.to_i.to_s == time_arr.first
    time_arr.join
  end
end
