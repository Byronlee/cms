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
end
