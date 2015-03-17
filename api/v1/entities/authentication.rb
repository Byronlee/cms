#    id         :integer          not null, primary key
#    uid        :string(255)
#    provider   :string(255)
#    raw        :text
#    user_id    :integer
#    created_at :datetime
#    updated_at :datetime
module V1
  module Entities
    class Authentication < Grape::Entity
      format_with(:iso8601) {|t| t.iso8601 if t }
      expose :id,       documentation: ''
      expose :uid,       documentation: ''
      expose :provider,       documentation: ''
      expose :raw,       documentation: ''
      expose :user_id,       documentation: ''
      expose :created_at,       documentation: ''
      expose :updated_at,       documentation: ''

    end
  end
end
