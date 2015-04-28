class Asynces::DashboardController < ApplicationController
  def chats
    response.headers['Access-Control-Expose-Headers'] = 'Location'
    @sessions = Authentication.today.count
    @posts_data, @users_data, @comments_data = chart_data
    @date_range = (9.days.ago.to_date..3.days.ago).map { |d| d.strftime('%d/%m') }
    render 'chats', layout: false
  end

  def pandect
    render 'pandect', layout: false
  end

  private

  # TODO: 优化查询语句
  # TODO: 补充测试
  def chart_data
    [Post, User, Comment].map do | obj |
       time_interval.inject([]) { |sum, day| sum << obj.by_day(day).count }
     end
  end

  def time_interval
   (9.days.ago.to_date..Date.today)
  end
end
