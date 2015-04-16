require 'spec_helper'

describe Admin::CommentsController do
  include Rails.application.routes.url_helpers
  login_admin_user

  let!(:comment) { create(:comment) }

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
      expect(response).to render_template(:admin)
      expect(assigns(:comments)).to eq([comment])
    end

    it "returns http success" do
      get 'index', post_id: comment.commentable.id
      response.should be_success
      expect(response).to render_template(:admin)
      expect(assigns(:comments)).to eq([comment])
    end
  end

  describe "DELETE 'destroy'" do
    it "returns http rediect" do
      request.env["HTTP_REFERER"] = post_show_by_url_code_path(comment.commentable.url_code)
      expect do
        delete :destroy, :id => comment
      end.to change(Comment, :count).by(-1)
      expect(response).to redirect_to(post_show_by_url_code_path(comment.commentable.url_code))
    end
  end

  describe "POST 'set_excellent'" do
    it 'change to excellent success' do
      request.env["HTTP_REFERER"] = admin_comments_path
      expect(comment.is_excellent?).to eq(false)
      post :set_excellent, id: comment, comment: { is_excellent: true }
      expect(assigns(:comment).is_excellent?).to eq(true)
      expect(response).to redirect_to(admin_comments_path)
    end
  end

  describe "POST 'do_publish'" do
    it 'change to published success' do
      request.env["HTTP_REFERER"] = admin_comments_path
      expect(comment.state).to eq('reviewing')
      post :do_publish, id: comment
      expect(assigns(:comment).state).to eq('published')
      expect(response).to redirect_to(admin_comments_path)
    end
  end

  describe "POST 'do_reject'" do
    it 'change to rejected success' do
      request.env["HTTP_REFERER"] = admin_comments_path
      expect(comment.state).to eq('reviewing')
      post :do_reject, id: comment
      expect(assigns(:comment).state).to eq('rejected')
      expect(response).to redirect_to(admin_comments_path)
    end
  end
end
