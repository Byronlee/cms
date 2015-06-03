module V2
  module Entities
    class Post < Grape::Entity
      format_with(:iso_timestamp) { |dt| dt.iso8601 if dt }
      expose :id         , documentation: 'not null, primary key'
      expose :title      , documentation: '标题'
      expose :summary    , documentation: '摘要'
      expose :column_id  , documentation: '专栏编号'
      expose :cover_real_url  , documentation: '封面图片'
      expose :author, using: Entities::User, documentation: '用户'
      expose :url_code   , documentation: '兼容旧站文章id'
      expose :comments_count , documentation: '评论计数'
      expose :views_count    , documentation: '来源计数'
      expose :related_links
      with_options(format_with: :iso_timestamp) do
        expose :published_at   , documentation: ''
      end
      expose :draft_key  , documentation: '草稿密匙'
    end
  end
end
