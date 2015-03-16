class LayoutCell < Cell::Rails
  helper ApplicationHelper
  include CanCan::ControllerAdditions
  delegate :current_ability, :to => :controller

  def nav(args)
    @current_user = args[:current_user]
    render
  end

  def footer
    render
  end
end
