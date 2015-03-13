module Admin::PostsHelper
  def display_state(state)
    case state
    when 'reviewing'
      raw "<span class='badge badge-warning'>#{state}</span>"
    when 'published'
      raw "<span class='badge badge-success'>#{state}</span>"
    else
      raw "<span class='badge badge-important'>#{state}</span>"
    end
  end
end
