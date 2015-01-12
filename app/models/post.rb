class Post < ActiveRecord::Base
  mount_uploader :cover, BaseUploader
   
  validates :title, :summary, :content, :title_link, presence: true
  validates :title,   length: { maximum: 40 }
  validates :summary, length: { maximum: 40 }
  validates :content, length: { maximum: 10000 }
  validates :slug,    length: { maximum: 14 }

end
