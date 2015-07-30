module WelcomeHelper
  def columns_header
    return @columns_header if @columns_header.present?
    columns_data = CacheClient.instance.columns_header
    @columns_header = JSON.parse(columns_data.present? ? columns_data : '{}')
  end
end
