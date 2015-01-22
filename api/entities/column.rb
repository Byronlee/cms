module API
  module APIEntities
    class Column < Base
      expose :id,         documentation: 'not null, primary key'
      expose :name,       documentation: ''
      expose :introduce,  documentation: ''
      expose :cover,      documentation: ''
      expose :icon,       documentation: ''
      expose :created_at, documentation: ''
      expose :updated_at, documentation: ''
      expose :posts,      documentation: ''
    end
  end
end
