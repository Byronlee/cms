require "faraday"
class UpdateElsearchIndexWorker < BaseWorker
	sidekiq_options :queue => :"#{Settings.sidekiq_evn.namespace}_search", :backtrace => true

  def perform url_code
    params = { id: url_code }
    response = Faraday.send(:post, Settings.kr_earch_server.send("#{Rails.env}_url"), params)
    #ActiveSupport::JSON.decode(response.body)
    response.body
  end

end
