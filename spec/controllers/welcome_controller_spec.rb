require 'spec_helper'

describe WelcomeController do
  include Rails.application.routes.url_helpers

  describe "GET 'index'" do
    context "match_krid_online_status" do
      before { allow(Rails.env).to receive(:test?) { false } }
      context "online" do
        login_user
        context "with matched version and id" do
          before { create(:authentication, user: session_user) }
          before { request.cookies[:krid_user_version] = session_user.krypton_authentication.version }
          before { request.cookies[:krid_user_id] = session_user.krypton_authentication.uid }
          before { get :index }
          it { should respond_with(:success) }
        end
        context "with unmatched version" do
          before { create(:authentication, user: session_user) }
          before { request.cookies[:krid_user_version] = session_user.krypton_authentication.version.to_i + 1 }
          before { request.cookies[:krid_user_id] = session_user.krypton_authentication.uid }
          before { get :index }
          it { should redirect_to(user_omniauth_authorize_path(provider: :krypton, ok_url: request.fullpath)) }
        end
        context "with unmatched krid" do
          before { create(:authentication, user: session_user) }
          before { request.cookies[:krid_user_version] = session_user.krypton_authentication.version }
          before { request.cookies[:krid_user_id] = session_user.krypton_authentication.uid.to_i + 1 }
          before { get :index }
          it { should redirect_to(user_omniauth_authorize_path(provider: :krypton, ok_url: request.fullpath)) }
        end
        context "but passport offline" do
          before { create(:authentication, user: session_user) }
          before { get :index }
          it {
            should respond_with(:success)
            expect(controller.current_user).to be_nil
          }
        end
      end
      context "offline" do
        context "with matched version" do
          before { get :index }
          it { should respond_with(:success) }
        end
        context "with unmatched version" do
          before { request.cookies[:krid_user_version] = 1 }
          before { get :index }
          it { should redirect_to(user_omniauth_authorize_path(provider: :krypton, ok_url: request.fullpath)) }
        end
        context "but passport online" do
          before { request.cookies[:krid_user_version] = 1 }
          before { get :index }
          it { should redirect_to(user_omniauth_authorize_path(provider: :krypton, ok_url: request.fullpath)) }
        end
      end
    end
  end

  describe "GET 'index'" do
    let(:post){ create :post, :published }
    before :each do
      create :main_site
    end

    context 'read cache index' do
      before { get :index }
      it do
        expect(response).to be_success
        expect(assigns(:next_page)).to eq 2
      end
    end

    context "html fragment" do 
      before { get :index, d: 'next', b_url_code: (post.url_code + 1), format: :html}
      it do
        should respond_with(:success)
        should render_template('welcome/_info_flows')
      end
    end

    context 'json' do
      before { xhr :get, :index, page: 2, format: :json}
      it do
        should respond_with(:success)
        expect(response.headers['Content-Type']).to include 'application/json'
      end
    end
  end

  describe "GET 'changes'" do
    before { get :changes }
    it do
      should respond_with(:success)
      expect(assigns[:changes].present?).to eq true
    end
  end

  describe "GET 'site_map'" do
    before { create :main_site }
    before { get 'site_map', { format: :xml} }
    it do
      expect(response).to be_success
      expect(response.headers['Content-Type']).to include 'application/xml'
    end
  end
end
