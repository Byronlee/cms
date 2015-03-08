require 'spec_helper'
require 'securerandom'

describe Users::OmniauthCallbacksController do
  include Rails.application.routes.url_helpers

  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe "GET 'krypton'" do
    before { request.env['omniauth.auth'] = authentication.raw }
    context "not bound" do
      context "already has user with same email(for data migration)" do
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
      context "already has user with email mocked by sns id" do
        let(:uid) { SecureRandom.hex(6) }
        let(:provider) { "weibo" }
        let(:authentication) { build :authentication }
        let!(:user) { create :user, email: "#{provider}+#{uid}@36kr.com" }
        before { allow(Krypton::Passport).to receive(:get_origin_ids) {
            { "#{provider}" => uid }
          }
        }
        before { post :krypton }
        it {
          should respond_with(:redirect)
          expect(user.reload.authentications.first.uid).to eq(authentication.uid)
        }
      end
    end
  end
end
