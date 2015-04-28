module Admin::PostsHelper
  def display_state(state)
    case state
    when 'reviewing'
      raw "<span title='待审查' style='padding-right: 0;'><i class='fa fa-question'></i></span>"
    when 'published'
      raw "<span title='已发布'  style='padding-right: 0;'><i class='fa fa-check'></i></span>"
    else
      raw "<span title='错误状态'  style='padding-right: 0;'><i class='fa fa-remove'></i></span>"
    end
  end
end
