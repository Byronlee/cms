require 'securerandom'

FactoryGirl.define do
  factory :authentication do
    user
    auth do
      {
        "provider" => "krpton",
        "uid" => SecureRandom.hex(32),
        "info" => {
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
    uid { auth["uid"] }
    provider { auth["provider"] }

  end
end
