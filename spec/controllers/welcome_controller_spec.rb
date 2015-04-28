require 'spec_helper'

describe WelcomeController do
  include Rails.application.routes.url_helpers

  describe "GET 'index'" do
    context 'read cache index' do
      before { get :index }
      it do
        expect(response).to be_success
        expect(assigns(:next_page)).to eq 2
      end
    end

    context "match_krid_online_status" do
      before { allow(Rails.env).to receive(:test?) { false } }
      context "online" do
        login_user
        context "with matched version" do
          before { create(:authentication, user: session_user) }
          before { request.cookies[:krid_user_version] = session_user.krypton_authentication.version }
          before { get :index }
          it { should respond_with(:success) }
        end
        context "with unmatched version" do
          before { create(:authentication, user: session_user) }
          before { request.cookies[:krid_user_version] = session_user.krypton_authentication.version.to_i + 1 }
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
    context 'read database index' do
      before :each do
        create :post, :published
        create :main_site
      end

      it do
        get :index, page: 2
        expect(response).to be_success
        expect(assigns(:prev_page)).to eq 1
      end
    end
  end

  describe "GET 'archives'" do
    before :each do
      create :post, :published
    end

    it do
      get :archives, :year => Date.today.year
      expect(response).to be_success
      expect(assigns(:posts).length).to eq 1
    end

    it do
      get :archives, :year => Date.today.year, :month => Date.today.month
      expect(response).to be_success
      expect(assigns(:posts).length).to eq 1
    end

    it do
      get :archives, :year => Date.today.year, :month => Date.today.month, :day => Date.today.day
      expect(response).to be_success
      expect(assigns(:posts).length).to eq 1
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
