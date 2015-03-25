module Admin::PostsHelper
  def display_state(state)
    case state
    when 'reviewing'
      raw "<span class='label label-warning'>#{state}</span>"
    when 'published'
      raw "<span class='label label-success'>#{state}</span>"
    else
      raw "<span class='label label-important'>#{state}</span>"
    end
  end
end
