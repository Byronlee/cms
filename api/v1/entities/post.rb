module API
  module V1
    module APIEntities
      class Post < Base
        expose :id         , documentation: 'not null, primary key'
        expose :title      , documentation: '标题'
        expose :summary    , documentation: '摘要'
        expose :content    , documentation: '内容'
        expose :title_link , documentation: '标题链接'
        expose :must_read  , documentation: '必读文章'
        expose :slug       , documentation: '短标题'
        expose :state      , documentation: '状态'
        expose :draft_key  , documentation: '草稿密匙'
        expose :created_at , documentation: ''
        expose :updated_at , documentation: ''
        expose :cover      , documentation: '封面图片'
      end
    end
  end
end
