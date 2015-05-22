# == Schema Information
#
# Table name: columns
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  introduce   :text
#  created_at  :datetime
#  updated_at  :datetime
#  cover       :string(255)
#  icon        :string(255)
#  posts_count :integer
#  slug        :string(255)
#  order_num   :integer
#

class Column < ActiveRecord::Base
  paginates_per 20
  mount_uploader :cover, BaseUploader
  mount_uploader :icon,  BaseUploader

  validates :name, :introduce, :slug, presence: true
  validates :name,      length: { maximum: 10 }
  validates :slug,      length: { maximum: 50 }
  validates :introduce, length: { maximum: 140 }
  validates_uniqueness_of :slug

  has_many :posts, dependent: :destroy
  has_many :contributors, class_name: User.to_s, foreign_key: :user_ids
  has_and_belongs_to_many :info_flows

  scope :info_flows, -> { where(in_info_flow: true) }
  scope :headers,    -> { where("order_num > ?", 0 ).order(order_num: :desc) }

  def weekly_posts_count
    posts.by_week.published.count
  end

  after_save :update_columns_header_cache
  def update_columns_header_cache
    return true  unless [self.name_changed?, self.slug_changed?, self.order_num_changed?].any?
    ColumnsHeaderComponentWorker.new.perform
  end

end
