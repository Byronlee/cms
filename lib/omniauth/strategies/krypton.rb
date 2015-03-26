require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Krypton < OmniAuth::Strategies::OAuth2
      # change the class name and the :name option to match your application name
      option :name, :krypton
      option :client_options, {
        site: Settings.oauth.krypton.host,
        authorize_url: "/oauth/authorize"
      }

      uid { raw_info["id"] }

      info do
        {
          name: raw_info["username"],
          email: raw_info["email"],
          nickname: raw_info["nickname"],
          phone: raw_info["phone"],
          image: raw_info["avatar"],
          location: raw_info["location"]
        }
      end

      extra do
        {
          version: raw_info["version"],
          raw_info: raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v1/users/me').parsed
      end

      def request_phase
        addon_params = request.params.slice("theme")
        redirect client.auth_code.authorize_url({:redirect_uri => callback_url}.merge(authorize_params).merge(addon_params))
      end

      def authorize_params
        params = super
        session['omniauth.state'] = params[:state] = "iframe" if request.params["theme"] == "iframe"
        params
      end
    end
  end
end