module V2
  module Entities
   class PostDetail < ::V2::Entities::Post
      expose :sanitize_content, as: :content , documentation: '内容'
      expose :md_content , documentation: 'markdown内容'
    end
  end
end
