# == Schema Information
#
# Table name: columns_sites
#
#  id         :integer          not null, primary key
#  column_id  :integer
#  site_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  order_num  :integer          default(0)
#

class ColumnSite < ActiveRecord::Base
	self.table_name = "columns_sites"

	validates :column_id, :site_id, presence: true
  validates_uniqueness_of :column_id, scope: :site_id

  scope :important, -> { order(order_num: :desc) }

	belongs_to :column
	belongs_to :site
end
