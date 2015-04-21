require 'spec_helper'
require 'securerandom'

describe Users::OmniauthCallbacksController do
  include Rails.application.routes.url_helpers

  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe "GET 'krypton'" do
    before { request.env['omniauth.auth'] = authentication.raw }

    context "sign in" do
      let(:ok_url) { "http://google.com" }
      let(:state) { SecureRandom.hex }
      let(:authentication) { create :authentication }
      before { $redis.set("omniauth_krypton_ok-url_of_#{state}", ok_url) }
      before { get :krypton, state: state }
      it {
        should redirect_to(ok_url)
        expect(controller.current_user).not_to be_nil
      }
    end

    context "new user" do
      let(:authentication) { build :authentication }
      before { allow(Krypton::Passport).to receive(:get_origin_ids) { { } } }
      before { get :krypton }
      it {
        should respond_with(:redirect)
        expect(controller.current_user).not_to be_nil
      }
    end
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
          expect(controller.current_user).not_to be_nil
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
          expect(user.reload.authentications.first.uid).to eq(authentication.uid.to_s)
          expect(controller.current_user).not_to be_nil
        }
      end
    end
  end
end