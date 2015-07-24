# == Schema Information
#
# Table name: sites
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  description  :text
#  domain       :string(255)
#  info_flow_id :integer
#  admin_id     :integer
#  created_at   :datetime
#  updated_at   :datetime
#  slug         :string(255)
#

require 'spec_helper'

describe Site do
  
end
