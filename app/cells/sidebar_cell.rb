class SidebarCell < Cell::Rails
  helper ApplicationHelper

  def ad_top(args)
    @position = args[:position]
    render
  end

  def ad_middle(args)
    @position = args[:position]
    render
  end

  def ad_bottom(args)
    @position = args[:position]
    render
  end

  def ad_job
    render
  end

  def hot_posts
    render
  end

  def new_posts
    render
  end

  def ad_sponsor
    render
  end

  def apps
    render
  end

  def excellent_comments
    render
  end

  def tags
    render
  end

  def social
    render
  end

  def today
    render
  end
end
