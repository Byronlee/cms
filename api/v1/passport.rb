class V1::Passport
  include Rails.application.routes.url_helpers

  def initialize(access_token_hash)
    @access_token_hash = access_token_hash
  end

  def me
    Hashie::Mash.new access_token.get("/api/v1/users/me").parsed
  rescue OAuth2::Error => e
    Rails.logger.error "#{e.code}, #{e.description}, #{e.response.body}"
  end

  def access_token
    @access_token ||= OAuth2::AccessToken.new client, @access_token_hash
  end

  def client
    @client ||= OAuth2::Client.new(Settings.oauth.krypton.app_id,
        Settings.oauth.krypton.secret, site: Settings.oauth.krypton.host)
  end
end
