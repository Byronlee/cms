# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default("")
#  phone                  :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  role                   :string(255)
#

require 'spec_helper'

describe User do
	let(:user) { create :user }
	
	it "用户默认角色是reader" do
		expect(user.role).to eql("reader")
		expect(user.role.reader?).to be_true
    expect(user.role_text).to eq("读者")
    expect(User.role.options).to include(["读者", "reader"])
	end
end