class SidebarCell < Cell::Rails
  helper ApplicationHelper
  include CanCan::ControllerAdditions
  delegate :current_ability, :to => :controller

  # TODO: 去掉每个Action都必写的render

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

  def ad_sponsor
    render
  end

  def apps
    render
  end

  def tags
    render
  end

  def social
    render
  end

  def today
    @posts = PostService.today_lastest
    render
  end

  def admin(args)
    @controller_name = args[:controller_name]
    @current_user = args[:current_user]
    @action_name = args[:action_name]
    render
  end
end
