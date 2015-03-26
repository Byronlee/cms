class SidebarCell < Cell::Rails
  helper ApplicationHelper
  include CanCan::ControllerAdditions
  delegate :current_ability, :to => :controller

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

  def today(args)
    @posts_count = args[:posts_today_lastest][:count]
    @posts = args[:posts_today_lastest][:posts]
    render
  end

  def admin args
    @controller_name = args[:controller_name]
    @current_user = args[:current_user]
    @action_name = args[:action_name]
    render
  end
end
