require 'common'
class HeadLinesComponentWorker < BaseWorker
  sidekiq_options :queue => :"#{Settings.sidekiq_evn.namespace}_third_party_headline", :backtrace => true

  def perform
    head_lines = HeadLine.published.where.not(title: [nil, ""]).order(updated_at: :desc).limit(3)
    head_lines = head_lines.sort { |a, b| b.order_num.to_i <=> a.order_num.to_i }
    Redis::HashKey.new('head_lines')['list'] = head_lines.to_json()
  end
end
