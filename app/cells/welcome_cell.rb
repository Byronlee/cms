class WelcomeCell < Cell::Rails
  helper PostsHelper
  helper ApplicationHelper

  def head_line
    head_lines_data = CacheClient.instance.head_lines
    @head_lines = head_lines_data.present? ? JSON.parse(head_lines_data) : []
    render
  end
end
