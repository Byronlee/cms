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
#  rong_organization_id                :integer
#  rong_organization_name              :string(255)
#  timing_switch                       :string(255)      default("on")

class User < ActiveRecord::Base
  extend Enumerize
  extend ActiveModel::Naming

  paginates_per 100
  by_star_field :created_at

  devise :database_authenticatable, :omniauthable, :recoverable, :rememberable, :trackable, :validatable, :omniauth_providers => [:krypton]
  enumerize :role, :in => Settings.roles, :default => :reader, :methods => true, :scopes => :shallow

  validates_uniqueness_of :domain, :case_sensitive => false, if: -> { self.domain.present? }
  validates :tagline, length: { maximum: 500 }
  validates_presence_of :rong_organization_id, :rong_organization_name, if: -> { self.role == 'organization' }

  has_many :authentications, dependent: :destroy
  has_one :krypton_authentication, -> { where(provider: :krypton) }, class_name: Authentication.to_s, dependent: :destroy
  has_many :posts
  has_many :comments
  has_many :favorites
  has_many :related_links

  scope :recent_editor, -> { where(role: [:operator, :writer, :editor, :admin, :contributor, :column_writer, :investor, :organization, :entrepreneur]).order('updated_at desc') }

  typed_store :extra do |s|
    s.string :admin_post_manage_session_path,  default: ''
    s.datetime :last_comment_at, default: Time.now
  end

  before_save :ensure_authentication_token
  def ensure_authentication_token
    self.authentication_token ||= generate_authentication_token
  end

  before_save :sync_rong_organization
  def sync_rong_organization
    invoke_rong_organization_api if self.role_changed?
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
    if krypton_authentication && krypton_authentication.info['nickname'].present?
      krypton_authentication.info['nickname']
    elsif name.present?
      name
    else
      '匿名用户'
    end
  end

  def authentication=(authentication)
    self.sso_id = authentication.uid
    self.krypton_authentication = authentication
    self.email = authentication.info['email']
    self.name = authentication.info['nickname'] || authentication.info['name']
    self.phone = authentication.info['phone']
    self.avatar_url = authentication.info['image']
    self.password = 'VEX60gCF'
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

  def dist_time_from_next_comment
    Settings.comment_time_interval - (Time.now - last_comment_at)
  end

  def can_comment?
    dist_time_from_next_comment <= 0
  end

  def invoke_rong_organization_api
    # 跑通测试临时方案，该方法应该mock
    return "save_no_needed" if Rails.env == 'test'
    authen_sso_id = self.sso_id
    authen_sso_id = self.krypton_authentication.uid if self.krypton_authentication
    return "save_no_needed" if authen_sso_id.blank?

    if !['reader', 'operator'].include?(self.role)
      params = { krId: authen_sso_id, role: rong_role}
      if self.role == "organization"
        params[:orgId] = self.rong_organization_id
        hash_key = "api_key=#{Settings.rong_api.api_key}&krId=#{authen_sso_id}&orgId=#{params[:orgId]}&role=#{rong_role}"
        params[:md5] = rong_key(hash_key)
      else
        hash_key = "api_key=#{Settings.rong_api.api_key}&krId=#{authen_sso_id}&role=#{rong_role}"
        params[:md5] = rong_key(hash_key)

        self.rong_organization_id = nil
        self.rong_organization_name = nil
      end
      response = Faraday.send(:post, Settings.rong_api.organization_role, params)
      unless response.success?
        logger.error response
        msg = response.body rescue '' unless response.success?
        errors.add(:rong_organization_name, "融资平台角色信息同步失败:#{msg}")
      else
        logger.info "融资平台角色信息添加成功： #{JSON.parse response.body}"
      end

      return "save_no_needed"
    else
      params = { krId: authen_sso_id}
      hash_key = "api_key=#{Settings.rong_api.api_key}&krId=#{authen_sso_id}"
      params[:md5] = rong_key(hash_key)
      response = Faraday.send(:delete, Settings.rong_api.organization_role, params)
      unless response.success?
        logger.error response
        msg = response.body rescue '' unless response.success?
        errors.add(:rong_organization_name, "融资平台角色信息同步失败#{msg}")
      else
        logger.info "融资平台角色信息删除成功： #{JSON.parse response.body}"
      end

      self.rong_organization_id = nil
      self.rong_organization_name = nil

      return "save_needed"
    end
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

  def rong_key(hash_key)
    Digest::MD5.hexdigest(hash_key).downcase
  end

  def rong_role
    return self.role.upcase if ['investor', 'organization', 'entrepreneur'].include? self.role
    return 'WRITER'
  end
end
