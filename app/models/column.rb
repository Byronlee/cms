# == Schema Information
#
# Table name: columns
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  introduce  :text
#  created_at :datetime
#  updated_at :datetime
#  cover      :string(255)
#  icon       :string(255)
#

class Column < ActiveRecord::Base
  mount_uploader :cover, BaseUploader
  mount_uploader :icon,  BaseUploader

  validates :name, :introduce, presence: true
  validates :name,      length: { maximum: 10 }
  validates :introduce, length: { maximum: 140 }

  has_many :posts, counter_cache: true, dependent: :destroy
  has_many :contributor, class_name: User.to_s
  
end
