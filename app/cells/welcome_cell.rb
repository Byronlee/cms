class WelcomeCell < Cell::Rails
  helper PostsHelper
  helper ApplicationHelper

  def head_line(args)
    head_lines_data = args[:head_lines]
    @head_lines = head_lines_data.present? ? JSON.parse(head_lines_data) : []
    render
  end
end
