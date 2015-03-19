module ApplicationHelper
  def show_tag_name(tag_name)
    case tag_name
    when 'krweekly'
      '氪周刊'
    else
      tag_name
    end
  end

  def avatar_url(avatar)
    return avatar if avatar
    asset_url "images/a-#{rand(1..3)}.jpg"
  end

  def post_url(arg)
    return arg.title_link unless arg.try(:title_link).blank?
    url_code = (arg.class.to_s == 'Fixnum' ? arg : arg.url_code)
    post_show_by_url_code_url(url_code)
  end

  def high_speed_url(raw_url, postfix)
    match = /(http:\/\/.\.36krcnd\.com)(.*)/.match(raw_url)
    return raw_url unless match
    host = "http://#{['a', 'b', 'c', 'd', 'e'][rand(5)]}.36krcnd.com"
    "#{host}#{match[2]}!#{postfix}"
  end

  def nav_active(local, target)
    return 'active' if local == target.to_sym
  end

  def reviewings_count
    @num ||= Post.reviewing.count
  end
end
