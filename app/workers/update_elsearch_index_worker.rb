require "faraday"
class UpdateElsearchIndexWorker < BaseWorker
	sidekiq_options :queue => :search, :backtrace => true

  def perform url_code
    params = { id: url_code }
    response = Faraday.send(:post, Settings.kr_earch_server.send("#{Rails.env}_url"), params)
    ActiveSupport::JSON.decode(response.body)
  end

end
