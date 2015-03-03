require 'spec_helper'
require 'securerandom'

describe Users::OmniauthCallbacksController do
  include Rails.application.routes.url_helpers

  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe "GET 'krypton'" do
    before { request.env['omniauth.auth'] = authentication.raw }
    context "not bound" do
      context "already has the user with same email(data migration)" do
        let(:user) { create :user }
        let(:authentication) {
          authentication = build :authentication
          authentication.info[:email] = user.email
          authentication
        }
        before { post :krypton }
        it {
          should respond_with(:redirect)
          expect(user.reload.authentications).not_to be_empty
        }
      end
    end
  end
end
