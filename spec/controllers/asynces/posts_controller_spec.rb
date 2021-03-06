require 'spec_helper'

describe Asynces::PostsController do
  include Rails.application.routes.url_helpers
  login_user

  describe "GET 'hot'" do
    before { get :hots }

    it 'return http success' do
      expect(response).to be_success
      expect(response).to render_template('asynces/posts/_hots')
    end
  end

  describe "GET 'today'" do
    let!(:post) { create :post }

    before do
      get :today
    end

    it 'return http success' do
      expect(response).to be_success
      expect(response).to render_template('asynces/posts/today')
    end
  end

  describe "GET 'today'" do
    before do
      get :record_post_manage_session_path, path: '/krypton/favorites'
    end

    it 'return http success' do
      expect(response).to be_success
      expect(assigns(:current_user).admin_post_manage_session_path).to eq '/krypton/favorites'
    end
  end
end
