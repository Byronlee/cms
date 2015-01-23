module API
  module V1
    module APIEntities
      class Base < Grape::Entity
        format_with(:iso8601) {|t| t.iso8601 if t }
      end
    end
  end
end
