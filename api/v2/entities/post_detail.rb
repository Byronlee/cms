module V2
  module Entities
    class PostDetail < ::V2::Entities::Post
      format_with(:iso_timestamp) { |dt| dt.iso8601 if dt }
      expose :sanitize_content, as: :content , documentation: '内容'
      expose :favoriter_sso_ids
      with_options(format_with: :iso_timestamp) do
        expose :created_at , documentation: ''
        expose :updated_at , documentation: ''
      end
    end
  end
end
