module V2
  module Entities
    class PostDetailAll < ::V2::Entities::Post
      format_with(:iso_timestamp) { |dt| dt.iso8601 if dt }
      expose :id         , documentation: 'not null, primary key'
      expose :sanitize_content, as: :content , documentation: '内容'
      expose :md_content , documentation: 'markdown内容'
      expose :title_link , documentation: '标题链接'
      expose :must_read  , documentation: '必读文章'
      expose :slug       , documentation: 'url别名-暂不用'
      expose :tag_list   , documentation: '标签'
      expose :state      , documentation: '状态'
      expose :user_id    , documentation: '用户'
      expose :source     , documentation: '来源'
      expose :catch_title    , documentation: '短标题'
      expose :key            , documentation: 'writer使用'
      expose :remark         , documentation: 'writer备注'
      expose :favoriter_sso_ids
      with_options(format_with: :iso_timestamp) do
        expose :created_at , documentation: ''
        expose :updated_at , documentation: ''
      end
    end
  end
end
