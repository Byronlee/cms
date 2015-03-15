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
#

class User < ActiveRecord::Base
  extend Enumerize
  paginates_per 20

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :omniauthable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauth_providers => [:krypton]
  enumerize :role, :in => Settings.roles, :default => :reader, :methods => true, :scopes => :shallow

  validates :phone, presence: true, uniqueness: true, allow_blank: -> { email.present? }
  validates :email, presence: true, uniqueness: true, allow_blank: -> { phone.present? }

  has_many :authentications, dependent: :destroy
  has_one :krypton_authentication, -> { where(provider: :krypton) }, class_name: Authentication.to_s
  has_many :posts
  has_many :comments

  before_save :ensure_authentication_token

  def ensure_authentication_token
    self.authentication_token ||= generate_authentication_token
  end

  def apply_omniauth(omniauth)
    self.phone = omniauth['info']['phone'] if phone.blank?
    authentications.build provider: omniauth['provider'], uid: omniauth['uid'],
      raw: omniauth.to_hash
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  def display_name
    if krypton_authentication && krypton_authentication.info['name'].present?
      krypton_authentication.info['name']
    else
      name.present? ? name : '匿名用户'
    end
  end

  def avatar
    return Settings.default_avatar unless self.krypton_authentication && self.krypton_authentication.info["image"].present?
    self.krypton_authentication.info['image']
  end

  def can_publish_comment?
    [:admin, :writer].include? role.to_sym
  end

  def can_prepublish_comment?
    [:editor].include? role.to_sym
  end

  def self.find_by_origin_ids(krypton_id)
    emails = Krypton::Passport.get_origin_ids(krypton_id).map do |provider, uid|
      "#{provider}+#{uid}@36kr.com"
    end
    User.where(email: emails).first
  end

  def editable
    Settings.editable_roles.include? role.to_sym
  end

  protected

  def email_required?
    false
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

end
