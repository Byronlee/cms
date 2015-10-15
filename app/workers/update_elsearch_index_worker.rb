require "faraday"
class UpdateElsearchIndexWorker < BaseWorker
	sidekiq_options :queue => :search, :backtrace => true

  def perform url_code
    params = { id: url_code }
    response = Faraday.send(:post, Settings.kr_search_server.send("#{Rails.env}_url"), params)
    #ActiveSupport::JSON.decode(response.body)
    response.body
  end

=begin
	settings.kr_search_server = {
	  development_url: 'http://rong.dev.36kr.com/news/receiver/v1',
	  production_url: 'http://rong.dev.36kr.com/news/receiver/v1',
	  test_url: 'http://rong.dev.36kr.com/news/receiver/v1'
	}
=end

end
