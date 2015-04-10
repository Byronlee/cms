require 'securerandom'

FactoryGirl.define do
  factory :authentication do
    user
    sequence(:raw) do |n| n
      {
        "provider" => "krypton",
        "uid" => 343,
        "info" => {
          "email" => "email#{n}@example.com",
          "phone" => 13412345678 + n,
          "nickname" => "Byronlee",
          "sex" => 1,
          "province" => "Beijing",
          "city" => "Beijing",
          "country" => "CN",
          "headimgurl" => "http://wx.qlogo.cn/mmopen/Zb0bdiau0sxVmcZkvD9OWvG6efGcvY0s4GykjAR8RCXPpwK4RXVhdyvlFbcDShN8dqoVbQOGqmCzwibQR4HPxz9Q/0",
          "name" => "Byronlee"
        }
      }
    end
    uid { raw["uid"] }
    provider { raw["provider"] }
  end
end