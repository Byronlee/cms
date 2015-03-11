module ApplicationHelper
  def show_tag_name(tag_name)
    case tag_name
    when 'krweekly'
      '氪周刊'
    else
      tag_name
    end
  end
end
