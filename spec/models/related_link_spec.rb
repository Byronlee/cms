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
#  user_id     :integer
#

require 'spec_helper'

describe RelatedLink do
  pending "add some examples to (or delete) #{__FILE__}"
end
