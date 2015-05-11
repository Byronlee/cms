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
#

class User < ActiveRecord::Base
  extend Enumerize
  extend ActiveModel::Naming

  paginates_per 100
  by_star_field :created_at

  devise :database_authenticatable, :omniauthable, :recoverable, :rememberable, :trackable, :validatable, :omniauth_providers => [:krypton]
  enumerize :role, :in => Settings.roles, :default => :reader, :methods => true, :scopes => :shallow

  has_many :authentications, dependent: :destroy
  has_one :krypton_authentication, -> { where(provider: :krypton) }, class_name: Authentication.to_s, dependent: :destroy
  has_many :posts
  has_many :comments
  has_many :favorites

  before_save :ensure_authentication_token
  def ensure_authentication_token
    self.authentication_token ||= generate_authentication_token
  end

  before_update :sync_role_to_writer
  def sync_role_to_writer
    return unless role_changed? && valid?
    SyncRoleToWriterWorker.perform_async(krypton_authentication.uid, role) rescue true
  end

  def apply_omniauth(omniauth)
    self.phone = omniauth['info']['phone'] if phone.blank?
    self.sso_id = omniauth['uid'] if sso_id.blank?
    self.name = omniauth['info']['nickname'] if name.blank?
    self.email = omniauth['info']['email'] if email.blank?&omniauth['info']['email'].present?
    authentications.build provider: omniauth['provider'], uid: omniauth['uid'],
      raw: omniauth.to_hash
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  def display_name
    return name if name.present?
    if krypton_authentication && krypton_authentication.info['name'].present?
      krypton_authentication.info['name']
    else
      '匿名用户'
    end
  end

  def avatar
    if krypton_authentication && krypton_authentication.info['image'].present?
      return krypton_authentication.info['image']
    elsif email.present?
      if /^weibo\+(\d+)@36kr\.com/ =~ email # weibo user
        return "http://tp3.sinaimg.cn/#{$1}/50/1"
      elsif /^qq\+(\w+)@36kr\.com/ =~ email # qq user
        return "http://qzapp.qlogo.cn/qzapp/100289813/#{$1}/100"
      else
        return "http://9429127371.a.uxengine.net/avatar/#{Digest::MD5.hexdigest(email)}.png?s=48&d=identicon&r=PG"
      end
    end

    Settings.default_avatars[id % 3]
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
    user = User.where(email: emails).first
    user.update_attribute(:sso_id, krypton_id) unless user.blank?
    user
  end

  def self.find_by_sso_id(krypton_id)
    User.where(sso_id: krypton_id).first
  end

  def editable
    Settings.editable_roles.include? role.to_sym
  end

  def muted?
    !!muted_at
  end

  def shutup!
    self.update muted_at: Time.now
  end

  def speak!
    self.update muted_at: nil
  end

  def like?(post)
    !!Favorite.find_by_url_code_and_user_id(post.url_code, id)
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
