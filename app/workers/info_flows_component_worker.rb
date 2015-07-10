class InfoFlowsComponentWorker < BaseWorker
	sidekiq_options :queue => :krx2015, :backtrace => true
	
  def perform(flow_name)
    info_flow = InfoFlow.find_by_name flow_name
    posts_with_ads = info_flow.posts_with_ads(page: 1, ads_required: true)
    Redis::HashKey.new('info_flow')[flow_name] =
      { :total_count => posts_with_ads[:total_count],
        :first_url_code => posts_with_ads[:first_url_code],
        :last_url_code => posts_with_ads[:last_url_code],
        :posts => posts_with_ads[:posts] }.to_json
  end
end