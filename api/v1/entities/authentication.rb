module V1
  module Entities
    class Authentication < Grape::Entity
      format_with(:iso_timestamp) { |dt| dt.iso8601 if dt }
      expose :id,       documentation: ''
      expose :uid,       documentation: ''
      expose :provider,       documentation: ''
      expose :raw,       documentation: ''
      expose :user_id,       documentation: ''
      with_options(format_with: :iso_timestamp) do
        expose :created_at,       documentation: ''
        expose :updated_at,       documentation: ''
      end

    end
  end
end
