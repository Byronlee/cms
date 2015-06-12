# == Schema Information
#
# Table name: authentications
#
#  id         :integer          not null, primary key
#  uid        :string(255)
#  provider   :string(255)
#  raw        :text
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Authentication < ActiveRecord::Base
  belongs_to :user
  by_star_field 'updated_at'
  store :raw, accessors: [:info], coder: JSON

  validates_uniqueness_of :provider, scope: :user_id

  def omniauth=(omniauth)
    self.provider = omniauth['provider']
    self.uid = omniauth['uid']
    self.raw = omniauth.to_hash
  end

  def version
    raw[:extra][:version]
  end

  def self.from_access_token(access_token)
    strategy = OmniAuth::Strategies::Krypton.new Rails.application, Devise.omniauth_configs[:krypton].strategy
    strategy.access_token = OAuth2::AccessToken.new strategy.client, access_token
    strategy

    return nil if (strategy.auth_hash.blank? || strategy.uid.nil? rescue Exception && true)

    exists = Authentication.find_by_provider_and_uid(:krypton, strategy.uid.to_s)
    return exists if exists

    return Authentication.new omniauth: strategy.auth_hash
  end

  private

  def auth_client
    @auth_client ||= OAuth2::Client.new(
      Settings.oauth.krypton.app_id,
      Settings.oauth.krypton.secret,
      site: Settings.oauth.krypton.host)
  end

  def get_access_token
    server_token = raw[:credentials]
    @access_token = OAuth2::AccessToken.new(auth_client, server_token[:token], server_token.slice(:refresh_token, :expires_at))
  end
end
