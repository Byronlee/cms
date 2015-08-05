# == Schema Information
#
# Table name: users
#
#  id                                  :integer          not null, primary key
#  email                               :string(255)
#  phone                               :string(255)
#  encrypted_password                  :string(255)      default(""), not null
#  reset_password_token                :string(255)
#  reset_password_sent_at              :datetime
#  remember_created_at                 :datetime
#  sign_in_count                       :integer          default(0), not null
#  current_sign_in_at                  :datetime
#  last_sign_in_at                     :datetime
#  current_sign_in_ip                  :string(255)
#  last_sign_in_ip                     :string(255)
#  created_at                          :datetime
#  updated_at                          :datetime
#  role                                :string(255)
#  authentication_token                :string(255)
#  name                                :string(255)
#  bio                                 :text
#  krypton_passport_invitation_sent_at :datetime
#  tagline                             :text
#  avatar_url                          :string(255)
#  sso_id                              :integer
#  muted_at                            :datetime
#  favorites_count                     :integer
#  extra                               :text
#  domain                              :string(255)
#

FactoryGirl.define do
  factory :user, aliases: [:author] do
    sequence(:email) { |n| "name#{n}@36kr.com" }
    sequence(:phone) { |n| "1388015659#{n}" }
    password { email }
    sequence(:sso_id) {|n| n}

    trait :admin do
      role :admin
    end

    trait :reader do
      role :reader
    end

    trait :contributor do
      role :contributor
    end

    trait :operator do
      role :operator
    end

    trait :writer do
      role :writer
    end

    trait :editor do
      role :editor
    end

    trait :column_writer do
      role :column_writer
    end

    factory :user_with_krypton_authentication do
      after(:create) do |user, evaluator|
        list = create_list(:authentication, 1, user: user, provider: :krypton)
        user.update_attribute(:sso_id, list.first.uid.to_i)
        list
      end
    end
  end
end
