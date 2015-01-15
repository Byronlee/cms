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
  store :raw, accessors: [ :info ], coder: JSON

  def omniauth= omniauth
    self.provider = omniauth['provider']
    self.uid = omniauth['uid']
    self.raw = omniauth.to_hash
  end

  def version
    raw[:extra][:version]
  end

private

  def auth_client
    @auth_client ||= OAuth2::Client.new(Settings.oauth.krypton.app_id, Settings.oauth.krypton.secret,
      site: Settings.oauth.krypton.host)
  end

  def get_access_token
    server_token = raw[:credentials]
    @access_token = OAuth2::AccessToken.new(auth_client, server_token[:token], server_token.slice(:refresh_token, :expires_at))
  end
end
