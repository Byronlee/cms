module Admin::CommentsHelper
  def display_comment_state(state)
    raw "<span title='#{Comment::STATE_OPTIONS[state.to_sym]}' class='badge #{comment_state_style(state)}'>#{Comment::STATE_OPTIONS[state.to_sym]}</i></span>"
  end


  def display_comment_state_with_tip(state)
    return if state == 'published'
    raw "<span title='#{comment_state_tip(state)}' class='badge #{comment_state_style(state)}'>#{Comment::STATE_OPTIONS[state.to_sym]}</i></span>"
  end

  private
  def comment_state_style(state)
    case state
    when 'reviewing'
      "badge-warning"
    when 'published'
      "badge-success"
    when 'rejected'
      "badge-fatal"
    end
  end


  def comment_state_tip(state)
    case state
    when 'reviewing'
      "该评论正在审查中, 仅对本人可见"
    when 'rejected'
      "该评论已经屏蔽，仅对本人可见"
    end
  end

end
