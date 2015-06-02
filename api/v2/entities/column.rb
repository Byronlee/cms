module V2
  module Entities
    class Column < Grape::Entity
      format_with(:iso_timestamp) { |dt| dt.iso8601 if dt }
      expose :id,         documentation: 'not null, primary key'
      expose :name,       documentation: ''
      expose :introduce,  documentation: ''
      expose :cover,      documentation: ''
      expose :icon,       documentation: ''
      expose :posts_count,documentation: ''
      expose :slug, documentation: ''
      expose :extra, documentation: ''
      with_options(format_with: :iso_timestamp) do
        expose :created_at, documentation: ''
        expose :updated_at, documentation: ''
      end
    end
  end
end
