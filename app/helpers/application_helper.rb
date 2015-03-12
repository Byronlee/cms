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
    asset_url "original/a-#{rand(1..3)}.jpg"
  end

  def post_url(arg)
    retuen arg.title_link unless arg.try(:title_link).blank?
    url_code = (arg.class.to_s == 'Fixnum' ? arg : arg.url_code)
    post_show_by_url_code_url(url_code)
  end
end
