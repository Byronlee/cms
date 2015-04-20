# == Schema Information
#
# Table name: pages
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  body       :text
#  slug       :text
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Page do
  # pending "add some examples to (or delete) #{__FILE__}"
end
