module V2
  module Entities
    class HeadLine < Grape::Entity
      format_with(:iso_timestamp) { |dt| dt.iso8601 if dt }
      expose :id
      expose :url
      expose :title
      expose :url_code
      expose :post_type
      expose :image
      expose :order_num
      with_options(format_with: :iso_timestamp) do
        expose :created_at
        expose :updated_at
      end
    end
  end
end
