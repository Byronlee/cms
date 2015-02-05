module V1
  module Entities
    class HeadLine < Grape::Entity
      format_with(:iso8601) {|t| t.iso8601 if t }
      expose :id
      expose :url
      expose :order_num
      expose :created_at
      expose :updated_at
      end
  end
end
