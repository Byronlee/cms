module V2
  module Entities
    class Search < Grape::Entity
      format_with(:iso_timestamp) { |dt| dt.iso8601 if dt }
      expose :title      , as: :Title , documentation: '标题'
      expose :summary    , as: :Description , documentation: '摘要'
      expose :cover_real_url, as: :PicUrl , documentation: ''
      expose :get_access_url , as: :Url, documentation: 'url'
    end
  end
end
