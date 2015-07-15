module V2
  module Entities
    class Site < Grape::Entity
      expose :id,           documentation: 'not null, primary key'
      expose :name,         documentation: ''
      expose :description,  documentation: ''
      expose :domain,       documentation: ''
      expose :admin_id,     documentation: ''
      expose :columns, using: Entities::Column, documentation: '专栏'
      expose :info_flow, using: Entities::InfoFlow, documentation: '信息流'
      format_with(:iso_timestamp) { |dt| dt.iso8601 if dt }
      with_options(format_with: :iso_timestamp) do
        expose :created_at, documentation: ''
        expose :updated_at, documentation: ''
      end
    end
  end
end
