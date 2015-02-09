require 'spec_helper'

describe Admin::CommentsController do

  let!(:comment){ create(:post_commentable) }

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
      expect(response).to render_template(:admin)
      expect(assigns(:comments)).to eq([comment])
    end
  end

  describe "DELETE 'destroy'" do
    it "returns http rediect" do
      request.env["HTTP_REFERER"] = post_path(comment.commentable)
      expect{
        delete :destroy, :id => comment
      }.to change(Comment, :count).by(-1)
      expect(response).to redirect_to(post_path(comment.commentable))
    end
  end

  describe "POST 'set_excellent'" do
    it 'change to excellent success' do
      request.env["HTTP_REFERER"] = admin_comments_path
      expect(comment.is_excellent?).to eq(false)
      post :set_excellent, id:comment, comment:{is_excellent:true}
      expect(assigns(:comment).is_excellent?).to eq(true)
      expect(response).to redirect_to(admin_comments_path)
    end
  end

  describe "POST 'do_publish'" do
    it 'change to published success' do
      request.env["HTTP_REFERER"] = admin_comments_path
      expect(comment.state).to eq('reviewing')
      post :do_publish, id:comment
      expect(assigns(:comment).state).to eq('published')
      expect(response).to redirect_to(admin_comments_path)
    end
  end

  describe "POST 'do_reject'" do
    it 'change to rejected success' do
      request.env["HTTP_REFERER"] = admin_comments_path
      expect(comment.state).to eq('reviewing')
      post :do_reject, id:comment
      expect(assigns(:comment).state).to eq('rejected')
      expect(response).to redirect_to(admin_comments_path)
    end
  end

end
