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
#  authentication_token   :string(255)
#  name                   :string(255)
#  bio                    :text
#

FactoryGirl.define do
  factory :user, aliases: [:author] do
    sequence(:email) { |n| "name#{n}@36kr.com" }
    sequence(:phone) { |n| "1388015659#{n}" }
    password { email }
  end
end
