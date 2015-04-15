require 'spec_helper'

describe Admin::PostsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "DELETE 'destroy'" do
    let!(:comment){ create(:post_commentable) }

    it "destroy self own comments" do
      request.env["HTTP_REFERER"] = post_path(comment.commentable)
      comments = comment.commentable.comments
      expect{
        delete :destroy, :id => comment.commentable
      }.to change(Post, :count).by(-1)
      expect(comments.blank?).to be_true
      expect(response).to redirect_to(post_path(comment.commentable))
    end

  describe "GET 'draft'" do
    let!(:comment){ create(:post, :drafted) }

    context "contributor can access draft page"
      login_user :contributor

      before{ get 'draft' }
      it do
        should respond_with(:success)
        should render_template(:draft)
      end
    end
  end

end
