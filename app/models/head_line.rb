# == Schema Information
#
# Table name: head_lines
#
#  id         :integer          not null, primary key
#  url        :string(255)
#  order_num  :integer
#  created_at :datetime
#  updated_at :datetime
#

class HeadLine < ActiveRecord::Base
	paginates_per 20

	validates :url, presence: true
	validates_uniqueness_of :url
end
