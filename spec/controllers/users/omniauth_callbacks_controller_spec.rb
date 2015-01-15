require 'spec_helper'
require 'securerandom'

describe Users::OmniauthCallbacksController do
  include Rails.application.routes.url_helpers

  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe "GET 'wechat'" do
    before do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:typton]
    end
  end  
end 
