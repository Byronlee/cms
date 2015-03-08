class Krypton::Passport
  class << self
    def invite(email)
      access_token.post("/api/v1/users/invite", {
        email: email
      }).parsed
    rescue OAuth2::Error => e
      case e.response.status
      when 422
        # email 有误(格式不正确 / 用户已经存在)
      end
    end

    def get_origin_ids(uid)
      access_token.get("/api/v1/users/#{uid}/origin_ids").parsed
    rescue OAuth2::Error => e
      case e.response.status
      when 404
      end
      return {}
    end
    end

    def find(key)
      access_token.get("/api/v1/users/show", { id: key })
    rescue OAuth2::Error => e
      case e.response.status
      when 404
        return nil
      else
        raise e
      end
    end

  private
    def access_token
      @access_token ||= begin
        client = OAuth2::Client.new(Settings.oauth.krypton.app_id, Settings.oauth.krypton.secret,
          site: Settings.oauth.krypton.host)
        if json = $redis.get(:krypton_passport_access_token)
          access_token = OAuth2::AccessToken.from_hash client, JSON.parse(json)
        else
          access_token = client.client_credentials.get_token
          $redis.set(:krypton_passport_access_token, access_token.to_json,
            ex: access_token.expires_in.seconds - 1.minute)
          access_token
        end
      end
    end
  end
end
