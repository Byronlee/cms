require 'spec_helper'

describe Admin::UsersController do
  login_admin_user

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
      expect(response).to render_template(:admin)
    end
  end

  describe "patch 'update'" do
    context 'update user info' do
      let(:user) { create :user }

      it do
        patch :update, id: user.id, user: attributes_for(:user)
        expect(response.status).to eq 302
      end
    end

    context 'reader cannot edit the role' do
      login_user(:reader)

      it do
        patch :update, id: session_user.id, user: {role: 'admin', email: 'lby@gma.com'}
        expect(session_user.reload.role).to eq 'reader'
        expect(response.status).to eq 302
      end
    end

    context 'admin can edit the role' do
      let(:user) { create :user, :reader }
      it do
        patch :update, id: user.id, user: {role: 'admin', email: 'lb@gma.com'}
        expect(user.reload.role).to eq 'admin'
        expect(response.status).to eq 302
      end
    end
  end

  describe "PUT 'shutup'" do
    let(:user) { create :user }
    before { put :shutup, id: user.id }
    it { expect(assigns[:user]).to be_muted }
  end

  describe "PUT 'speak'" do
    let(:user) { create :user, muted_at: Time.now }
    before { put :speak, id: user.id }
    it { expect(assigns[:user]).not_to be_muted }
  end

  describe "get 'simple_search'" do
    before do
      @user = create :user, :admin
    end

    it "returns http success" do
      get :index, s: { type: 'id', id: @user.id }
      expect(assigns(:users)).to eq [@user]
    end

    it "returns http success" do
      get :index, s: { type: 'email', email: @user.email }
      expect(assigns(:users)).to eq [@user]
    end
  end
end
