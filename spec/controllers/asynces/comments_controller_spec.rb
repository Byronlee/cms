require 'spec_helper'

describe Asynces::CommentsController do
  include Rails.application.routes.url_helpers
  login_admin_user

  let(:comment) { create(:comment) }
  before(:each) do
    comment.update_attributes(:is_excellent => true, :state => 'published')
  end

  describe "GET 'index'" do
    it 'returns http success' do
      get :index, post_id: comment.commentable
      response.should be_success
      expect(assigns(:commentable)).to eq(comment.commentable)
      expect(assigns(:comments)).to eq([comment])
      expect(response).to render_template('asynces/comments/list')
    end
  end

  describe "GET 'excellents'" do
    it 'returns http success' do
      get :excellents
      response.should be_success
      expect(response).to render_template('asynces/comments/excellents')
    end
  end

  describe "POST 'create'" do
    it 'returns http success' do
      post :create, post_id: comment.commentable.id, comment: attributes_for(:comment), current_maxid: 0
      expect(response).to be_success
      expect(assigns(:comment).is_long?).to be_false
      expect(response).to render_template('asynces/comments/list')
    end

    it 'should be long comment if length > 140' do
      post :create, post_id: comment.commentable, comment: { content: 'A' * 150 }, current_maxid: 0
      expect(assigns(:comment).is_long?).to be_true
    end

    it 'should be invalid if length > 3000' do
      post :create, post_id: comment.commentable, comment: { content: 'A' * 3001 }, current_maxid: 0
      assigns(:comment).errors[:content].empty?.should_not be_true
      assigns(:comment).errors[:content].first.should match(/过长/)
    end
  end
end
