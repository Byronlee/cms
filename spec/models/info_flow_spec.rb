# == Schema Information
#
# Table name: info_flows
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe InfoFlow do
  it do
    expect(InfoFlow::DEFAULT_INFOFLOW).to eq '主站'
  end

  describe '' do
  end
end
