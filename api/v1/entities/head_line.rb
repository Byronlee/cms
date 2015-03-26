module V1
  module Entities
    class HeadLine < Grape::Entity
      format_with(:iso_timestamp) { |dt| dt.iso8601 if dt }
      expose :url_code, as: :id
      expose :title
      expose :url
      expose :excerpt
      expose :image, as: :feature_img
      expose :post_type
      expose :order_num
      expose :replies_count
      with_options(format_with: :iso_timestamp) do
        expose :created_at
        expose :updated_at
      end
    end
  end
end
