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
#  order_num   :string(255)      default("0")
#

require 'spec_helper'

describe Column do
  # pending "add some examples to (or delete) #{__FILE__}"
end
