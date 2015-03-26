module Admin::PostsHelper
  def display_state(state)
    case state
    when 'reviewing'
      raw "<span class='label label-warning' title='待审查'><i class='fa fa-question'></i></span>"
    when 'published'
      raw "<span class='label label-success' title='已发布'><i class='fa fa-check'></i></span>"
    else
      raw "<span class='label label-important' title='错误状态'><i class='fa fa-remove'></i></span>"
    end
  end
end
