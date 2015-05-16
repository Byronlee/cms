require 'spec_helper'

describe UsersController do
  describe "GET 'messages'" do
    it 'returns http success' do
      get 'messages', data: { code: 0, data: { total: 2 } }
      response.should be_success
      expect(response).to render_template('users/_messages')
    end
  end

  describe "GET 'favorites'" do
    context 'current user is nil' do
      it do
        get 'favorites'
        expect(response).to redirect_to 'http://test.host/users/sign_in'
      end
    end

    context 'current user is valid' do
      login_admin_user

      it do
        get 'favorites'
        response.should be_success
        expect(assigns(:favorites).nil?).to eq false
        expect(response).to render_template('users/favorites')
      end
    end
  end

  describe "GET 'cancel_favorites'" do
    login_admin_user
    context 'no favorites' do
       let(:favorite){ create(:favorite) }
       before { get 'cancel_favorites', url_code: favorite.post.url_code }
       it { expect(assigns(:state)).to eq true }
    end

    context 'has favorites' do
      let(:favorite) { create :favorite, user: session_user }
      before { get 'cancel_favorites', url_code: favorite.post.url_code }
      it {
        expect(assigns(:state)).to be_false
      }
    end
  end

  describe "GET 'posts'" do
    let(:user){ create :user, domain: 'domain' }
    context 'returns http success' do
      before { get 'posts', user_domain: user.domain }
      it {
        expect(assigns(:user)).to eq user
        response.should be_success
        expect(response).to render_template('users/posts')
      }
    end
  end
end
