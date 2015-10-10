require 'faraday'

module Seo

  def self.writer template_id, params
    url = "#{Settings.kr_seo_server.send("#{Rails.env}_url")}/internal/seo/meta/#{template_id}/#{params[:id]}"
    response = Faraday.send(:put, url , params)
  end

  def self.read template_id, url_code
    url = "#{Settings.kr_seo_server.send("#{Rails.env}_url")}/internal/seo/meta/#{template_id}/#{url_code}"
    response = Faraday.send(:get, url)
  end

  #internal/seo/fragment/header-footer/<page-id>
  def self.read_header_footer page_id
    url = "#{Settings.kr_seo_server.send("#{Rails.env}_url")}/internal/seo/fragment/header-footer/#{page_id}"
    response = Faraday.send(:get, url)
  end

end
