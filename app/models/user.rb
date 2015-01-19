# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  phone                  :string(255)      not null
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
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauth_providers => [:krypton]

  has_many :authentications, dependent: :destroy
  has_many :posts
  has_one :krypton_authentication, -> { where(provider: :krypton) }, class_name: Authentication.to_s
  def apply_omniauth(omniauth)
    self.phone = omniauth['info']['phone'] if phone.blank?
    authentications.build provider: omniauth['provider'], uid: omniauth['uid'],
      raw: omniauth.to_hash
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  def name
    self.krypton_authentication.info["name"]
  end

protected

  def email_required?
    false
  end
end
