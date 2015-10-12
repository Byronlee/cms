module WelcomeHelper
  def columns_header
    return @columns_header if @columns_header.present?
    columns_data = CacheClient.instance.columns_header
    @columns_header = JSON.parse(columns_data.present? ? columns_data : '{}')
  end

  def seo meta
    [ Nokogiri::HTML.fragment(meta).css('title').to_html, Nokogiri::HTML.fragment(meta).css('meta').to_html ]
  end
end
