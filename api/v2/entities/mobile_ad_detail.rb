module V2
  module Entities
    class MobileAdDetail < ::V2::Entities::MobileAd
      expose :ad_title, :ad_url, :ad_img_url, :ad_summary, :state, :ad_enable_time, :ad_end_time
      format_with(:iso_timestamp) { |dt| dt.iso8601 if dt }
      with_options(format_with: :iso_timestamp) do
        expose :created_at, documentation: ''
        expose :updated_at, documentation: ''
      end

    end
  end
end
