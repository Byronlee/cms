module Admin::CommentsHelper
  def display_comment_state(state)
    case state
    when 'reviewing'
      raw "<span title='审查中' class='badge badge-warning'>#{state}</i></span>"
    when 'published'
      raw "<span title='已发布' class='badge badge-success'>#{state}</i></span>"
    else
      raw "<span title='已屏蔽' class='badge badge-fatal'>#{state}</i></span>"
    end
  end

end
