module V1
  module Entities
    class Post < Grape::Entity
      format_with(:iso8601) {|t| t.iso8601 if t }
      expose :id         , documentation: 'not null, primary key'
      expose :title      , documentation: '标题'
      expose :summary    , documentation: '摘要'
      expose :content    , documentation: '内容'
      expose :md_content , documentation: 'markdown内容'
      expose :title_link , documentation: '标题链接'
      expose :column_id  , documentation: '专栏编号'
      expose :must_read  , documentation: '必读文章'
      expose :slug       , documentation: '短标题'
      expose :state      , documentation: '状态'
      expose :draft_key  , documentation: '草稿密匙'
      expose :created_at , documentation: ''
      expose :updated_at , documentation: ''
      expose :cover      , documentation: '封面图片'
      expose :user_id    , documentation: '用户'
      expose :url_code   , documentation: '兼容旧站文章id'
      expose :source     , documentation: '来源'
      expose :comments_count , documentation: '评论计数'
      expose :views_count    , documentation: '来源计数'
      expose :catch_title    , documentation: ''
      expose :published_at   , documentation: ''
      expose :key            , documentation: ''
      expose :remark         , documentation: ''
    end
  end
end
