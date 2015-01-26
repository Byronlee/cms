module API
  module V1
    module Entities
      class Column < Base
        expose :id,         documentation: 'not null, primary key'
        expose :name,       documentation: ''
        expose :introduce,  documentation: ''
        expose :cover,      documentation: ''
        expose :icon,       documentation: ''
        expose :created_at, documentation: ''
        expose :updated_at, documentation: ''
      end
    end
  end
end
