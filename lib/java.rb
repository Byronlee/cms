require 'faraday'

module Java
	module Search

	def self.search params
    url = "#{Settings.kr_search_server.send("#{Rails.env}_url")}&word=#{params[:q]}&published_at=#{params[:published_at]}&pageSize=#{params[:per_page] || '30'}"
    response = Faraday.send(:get, url )
    data = ActiveSupport::JSON.decode(response.body)
  end

	end

end