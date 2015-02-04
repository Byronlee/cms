# == Schema Information
#
# Table name: newsflash_topic_colors
#
#  id         :integer          not null, primary key
#  site_name  :string(255)
#  color      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class NewsflashTopicColor < ActiveRecord::Base
  validates_presence_of :site_name, :color

  has_many :newsflashes
end
