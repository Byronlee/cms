require 'common'
class HeadLinesComponentWorker < BaseWorker
  sidekiq_options :queue => :third_party_headline, :backtrace => true

  def perform
    head_lines_normal = HeadLine.published.normal.where.not(title: [nil, ""]).order(updated_at: :desc).limit(5)
    head_lines_normal = head_lines_normal.sort { |a, b| b.order_num.to_i <=> a.order_num.to_i }
    head_lines_next = HeadLine.published.next.where.not(title: [nil, ""]).order(updated_at: :desc).limit(1)
    head_lines_top = HeadLine.published.top.where.not(title: [nil, ""]).order(updated_at: :desc).limit(1)

    Redis::HashKey.new('head_lines')['list_new'] = {normal: head_lines_normal, next: head_lines_next, top:head_lines_top}.to_json()
  end
end
