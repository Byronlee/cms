module V2
  module Entities
    class InfoFlow < Grape::Entity
      expose :id,           documentation: 'not null, primary key'
      expose :name,         documentation: ''
      format_with(:iso_timestamp) { |dt| dt.iso8601 if dt }
      with_options(format_with: :iso_timestamp) do
        expose :created_at, documentation: ''
        expose :updated_at, documentation: ''
      end
    end
  end
end
