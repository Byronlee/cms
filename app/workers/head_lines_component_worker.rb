class HeadLinesComponentWorker < BaseWorker
  def perform
    head_lines = HeadLine.order('updated_at desc').limit(5)
    head_lines = head_lines.sort { |a, b| b.order_num.to_i <=> a.order_num.to_i }
    @collections = head_lines.inject([]) do | result, head_line |
      result << prase(head_line.url)
    end
    Redis::HashKey.new('head_lines')['list'] = @collections.to_json
  end

  private

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
