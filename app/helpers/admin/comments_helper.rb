module Admin::CommentsHelper
  def display_state(state)
    case state
    when 'reviewing'
      raw "<span class='badge badge-warning'>#{state}</span>"
    when 'republished'
      raw "<span class='badge badge-info'>#{state}</span>"
    when 'published'
      raw "<span class='badge badge-success'>#{state}</span>"
    when 'reject'
      raw "<span class='badge badge-default'>#{state}</span>"
    else
      raw "<span class='badge badge-important'>#{state}</span>"
    end
  end
end
