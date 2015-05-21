module V1
  module Entities
    class Post < Grape::Entity
      format_with(:iso_timestamp) { |dt| dt.iso8601 if dt }
      expose :url_code, as: :id   , documentation: '兼容旧站文章id'
      expose :title      , documentation: '标题'
      expose :summary, as: :excerpt, documentation: '摘要'
      expose :sanitize_content, as: :body_html , documentation: '内容'
      expose :md_content , documentation: 'markdown内容'
      expose :title_link , documentation: '标题链接'
      expose :column_id, as: :node_id  , documentation: '专栏编号'
      expose :column_name, as: :node_name  , documentation: '专栏编号'
      expose :comments_counts, as: :replies_count , documentation: '评论计数'
      expose :tag_list, as: :tags
      expose :must_read  , documentation: '必读文章'
      expose :slug       , documentation: 'url别名-暂不用'
      expose :state      , documentation: '状态'
      expose :draft_key  , documentation: '草稿密匙'
      expose :cover_real_url, as: :feature_img , documentation: '封面图片'
      expose :user_id    , documentation: '用户'
      expose :author, as: :user, using: Entities::User, documentation: '用户'
      expose :comments, as: :replies, using: Entities::Comment, documentation: '评论'
      expose :source     , documentation: '来源'
      expose :views_count    , documentation: '来源计数'
      expose :catch_title    , documentation: '短标题'
      expose :key            , documentation: 'writer使用'
      #expose :remark         , documentation: 'writer备注'
      with_options(format_with: :iso_timestamp) do
        expose :created_at, documentation: ''
        expose :published_at , documentation: ''
        expose :updated_at, documentation: ''
      end
    end
  end
end
