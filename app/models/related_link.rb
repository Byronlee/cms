# == Schema Information
#
# Table name: related_links
#
#  id          :integer          not null, primary key
#  url         :string(255)
#  link_type   :string(255)
#  title       :string(255)
#  image       :string(255)
#  description :text
#  extra       :text
#  created_at  :datetime
#  updated_at  :datetime
#  post_id     :integer
#

class RelatedLink < ActiveRecord::Base
  typed_store :extra do |s|
    s.text :video_url, default: ''
    s.integer :video_duration, default: 0
  end

  belongs_to :post
end
