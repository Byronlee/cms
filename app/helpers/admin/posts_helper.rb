module Admin::PostsHelper
  def display_state(state)
    case state
    when 'reviewing'
      raw "<span class='label label-warning'><i class='fa fa-check'></i></span>"
    when 'published'
      raw "<span class='label label-success'><i class='fa fa-check'></i></span>"
    else
      raw "<span class='label label-important'><i class='fa fa-check'></i></span>"
    end
  end
end
