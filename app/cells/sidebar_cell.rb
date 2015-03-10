class SidebarCell < Cell::Rails
  def ad_top(args)
    @position = args[:position]
    render
  end

  def ad_middle(args)
    @position = args[:position]
    render
  end

  def hot_posts
    render
  end

  def new_posts
    render
  end

  def sponsor
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
