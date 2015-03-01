class InfoFlowsComponentWorker < BaseWorker
  def perform(flow_name)
    info_flow = InfoFlow.find_by_name flow_name
    posts_with_ads, total_count = info_flow.posts_with_ads(1)
    Redis::HashKey.new('info_flow')[flow_name] =
      { :totle_count => total_count,
        :posts_with_ads => posts_with_ads }.to_json
  end
end