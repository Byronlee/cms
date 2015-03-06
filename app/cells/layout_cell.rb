class LayoutCell < Cell::Rails
  def nav(args)
    @current_user = args[:current_user]
    render
  end

  def footer
    render
  end
end
