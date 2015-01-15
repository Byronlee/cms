module API
  module APIEntities
    class Post < Grape::Entity
       expose :id, :title, :created_at, :updated_at, :summary, :content,
         :title_link, :must_read, :slug, :state, :draft_key, :cover
    end
  end
end
