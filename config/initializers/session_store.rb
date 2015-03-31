# Be sure to restart your server when you modify this file.
Kr::Application.config.session_store :redis_store,
  namespace: '_krypton_session', key: '_krypton_session',
  redis_server: Settings.redis_servers.session,
  domain: '.36kr.com', expires_in: 1.years

#Rails.application.config.session_store  ActionDispatch::Session::CacheStore,
#  key: '_krypton_session',
#  domain: :all,
#  expire_after: 1.years
