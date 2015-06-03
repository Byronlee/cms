class InfoFlowsComponentWorker < BaseWorker
	sidekiq_options :queue => :"#{Settings.sidekiq_evn.namespace}_krx2015", :backtrace => true
	
  def perform(flow_name)
    info_flow = InfoFlow.find_by_name flow_name
    posts_with_ads, total_count, prev_page, next_page, min_url_code, max_url_code  = info_flow.posts_with_ads(1)
    Redis::HashKey.new('info_flow')[flow_name] =
      { :total_count => total_count,
        :prev_page => prev_page,
        :next_page => next_page,
        :min_url_code => min_url_code,
        :max_url_code => max_url_code,
        :posts_with_ads => posts_with_ads }.to_json
  end
end