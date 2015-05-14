require 'common'
class HeadLinesComponentWorker < BaseWorker
  sidekiq_options :queue => :third_party_headline, :backtrace => true

  def perform(head_line)
    fetch_meta_info(head_line)
    cache_top_list_to_redis
  end

  private

  def fetch_meta_info(head_line)
    metas = prase(head_line.url)
    return if metas.blank?
    head_line.title = metas[:title]
    head_line.post_type = metas[:type]
    head_line.image = metas[:image]
    head_line.url_code = metas[:code]
    head_line.save
  end

  def cache_top_list_to_redis
    head_lines = HeadLine.published.where("title is not null and title <> ''").order('updated_at desc').limit(5)
    head_lines = head_lines.sort { |a, b| b.order_num.to_i <=> a.order_num.to_i }
    Redis::HashKey.new('head_lines')['list'] = head_lines.to_json
  end

  def valid_of?(url)
    begin
      io = open(url)
      return true if(io.status.include?('200') || io.status.include?('302'))
    rescue
      return false
    end
  end

  def get_customer_meta_of(og, meta)
    return nil if og.metadata[meta].blank? || og.metadata[meta].first.blank?
    og.metadata[meta].first[:_value]
  end

  def prase(url)
    return {} unless valid_of?(url)
    og = OpenGraph.new(url)
    binding.pry
    {
      title: og.title,
      type: og.type,
      url: og.url,
      code: get_customer_meta_of(og, :code),
      image: og.images.first
    }
  end
end
