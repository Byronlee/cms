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
      expect(comments.blank?).should be_true
      expect(response).to redirect_to(post_path(comment.commentable))
    end
  end

end
