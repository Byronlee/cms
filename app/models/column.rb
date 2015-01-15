class Column < ActiveRecord::Base
  mount_uploader :cover, BaseUploader
  mount_uploader :icon,  BaseUploader

  validates :name, :introduce, presence: true
  validates :name,      length: { maximum: 10 }
  validates :introduce, length: { maximum: 140 }

  has_many :posts, counter_cache: true, dependent: :destroy
  has_many :contributor, class_name: User.to_s
  
end
