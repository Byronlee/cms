module V2
  module Entities
    class Favorite < Grape::Entity
      format_with(:iso_timestamp) { |dt| dt.iso8601 if dt }
      expose :id
      expose :url_code
      expose :user_id
      with_options(format_with: :iso_timestamp) do
        expose :created_at, documentation: ''
        expose :updated_at, documentation: ''
      end
    end
  end
end
