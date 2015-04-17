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

  describe "GET 'commets_count'" do
    let(:post) { create :post }

    before do
      get :comments_count, id: post.id
    end

    it 'return http success' do
      expect(response).to be_success
      response.header['Content-Type'].should include 'application/json'
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
end
