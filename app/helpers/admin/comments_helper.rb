module Admin::CommentsHelper
  def display_comment_state(state)
    case state
    when 'reviewing'
      raw "<span title='审查中' class='badge badge-warning'>审查中</i></span>"
    when 'published'
      raw "<span title='已发布' class='badge badge-success'>已发布</i></span>"
    when 'rejected'
      raw "<span title='已屏蔽' class='badge badge-fatal'>已屏蔽</i></span>"
    end
  end


  def display_comment_state_with_tip(state)
    case state
    when 'reviewing'
      raw "<span title='审查中, 该评论仅本人可见' class='badge badge-warning'>审查中</i></span>"
    when 'rejected'
      raw "<span title='已屏蔽，该评论仅本人可见' class='badge badge-fatal'>已屏蔽</i></span>"
    end
  end

end
