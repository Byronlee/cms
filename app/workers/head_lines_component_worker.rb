class HeadLinesComponentWorker < BaseWorker
  def perform
    fetch_meta_info
    cache_top_list_to_redis
  end

  private

  def fetch_meta_info
    HeadLine.order('created_at asc').each do |head_line|
      next if head_line.title.present?
      metas = prase(head_line.url)
      head_line.title = metas[:title]
      head_line.post_type = metas[:type]
      head_line.image = metas[:image]
      head_line.save
    end
  end

  def cache_top_list_to_redis
    head_lines = HeadLine.order('updated_at desc').limit(5)
    head_lines = head_lines.sort { |a, b| b.order_num.to_i <=> a.order_num.to_i }
    Redis::HashKey.new('head_lines')['list'] = head_lines.to_json
  end

  def prase(url)
    og = OpenGraph.new(url)

    {
      title: og.title,
      type: og.type,
      url: og.url,
      image: og.images.first
    }
  end
end
