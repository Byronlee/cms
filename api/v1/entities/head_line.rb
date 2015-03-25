module V1
  module Entities
    class HeadLine < Grape::Entity
      format_with(:iso8601) {|t| t.iso8601 if t }
      expose :url_code, as: :id
      expose :url
      expose :title
      expose :post_type
      expose :image, as: :feature_img
      expose :order_num
      expose :replies_count
      expose :created_at
      expose :updated_at
      end
  end
end
