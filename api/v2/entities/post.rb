module V2
  module Entities
    class Post < Grape::Entity
      format_with(:iso_timestamp) { |dt| dt.iso8601 }
      expose :id         , documentation: 'not null, primary key'
      expose :title      , documentation: '标题'
      expose :summary    , documentation: '摘要'
      expose :content    , documentation: '内容'
      expose :md_content , documentation: 'markdown内容'
      expose :title_link , documentation: '标题链接'
      expose :column_id  , documentation: '专栏编号'
      expose :must_read  , documentation: '必读文章'
      expose :slug       , documentation: 'url别名-暂不用'
      expose :state      , documentation: '状态'
      expose :draft_key  , documentation: '草稿密匙'
      expose :cover_real_url  , documentation: '封面图片'
      expose :user_id    , documentation: '用户'
      expose :author, using: Entities::User, documentation: '用户'
      expose :url_code   , documentation: '兼容旧站文章id'
      expose :source     , documentation: '来源'
      expose :comments_count , documentation: '评论计数'
      expose :views_count    , documentation: '来源计数'
      expose :catch_title    , documentation: '短标题'
      expose :key            , documentation: 'writer使用'
      expose :remark         , documentation: 'writer备注'
      with_options(format_with: :iso_timestamp) do
        expose :published_at   , documentation: ''
        expose :created_at , documentation: ''
        expose :updated_at , documentation: ''
      end
    end
  end
end
