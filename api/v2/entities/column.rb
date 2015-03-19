module V2
  module Entities
    class Column < Grape::Entity
      format_with(:iso8601) {|t| t.iso8601 if t }
      expose :id,         documentation: 'not null, primary key'
      expose :name,       documentation: ''
      expose :introduce,  documentation: ''
      expose :cover,      documentation: ''
      expose :icon,       documentation: ''
      expose :created_at, documentation: ''
      expose :updated_at, documentation: ''
      expose :posts_count,documentation: ''
      expose :slug, documentation: ''
    end
  end
end
