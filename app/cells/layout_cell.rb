class LayoutCell < Cell::Rails
  helper ApplicationHelper

  def nav(args)
    @current_user = args[:current_user]
    render
  end

  def footer
    render
  end
end
