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

	paginates_per 2

	validates :url, presence: true
	validates_uniqueness_of :url

	after_destroy :fetch_remote_metas
	after_save :fetch_remote_metas

	private 

	def fetch_remote_metas
	  logger.info "perform the worker to fetch remote metas"
	  logger.info HeadLinesComponentWorker.perform_async
  end

end
