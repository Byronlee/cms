# == Schema Information
#
# Table name: headlines
#
#  id         :integer          not null, primary key
#  url        :string(255)
#  order_num  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Headline < ActiveRecord::Base
	paginates_per 2

	validates :url, presence: true
	validates_uniqueness_of :url
end
