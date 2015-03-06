require 'spec_helper'

describe CommentsController do
  let!(:comment){
    create(:post_commentable)
  }
  let!(:user){ comment.user}
  let!(:comment2){
    post = comment.commentable
    comment2 = post.comments.build(:content => 'A' * 150)
    comment2.user = user
    comment2.save
    comment2
  }

  before(:each) do
    controller.stub(:current_user).and_return(user)
    comment.update_attributes({:is_excellent => true, :state => 'published'})
  end

  describe "GET 'index'" do
    it "returns http success" do
      xhr :get, :index, post_id:comment.commentable, format:'js'
      response.should be_success
      expect(assigns(:commentable_type)).to eq('posts')
      expect(assigns(:commentable_id )).to eq(comment.commentable.id)
      expect(assigns(:comments )).to eq([comment])
      expect(assigns(:comments_normal_count )).to eq(1)
    end
  end

  describe "GET 'normal_list'" do
    it "returns http success" do
      xhr :get, :normal_list, post_id:comment.commentable, format:'js'
      response.should be_success
      expect(assigns(:comments )).to eq([comment2])
      expect(assigns(:comments_normal_count )).to eq(1)
    end
  end

  describe "POST 'create'" do
    it "returns http success" do
      request.env["HTTP_REFERER"] = post_path(comment.commentable)
      expect{
        post :create, post_id:comment.commentable, comment: attributes_for(:comment), format:'js'
      }.to change(Comment, :count).by(1)
      expect(assigns(:comment).is_long?).to  be_false
      expect(response).to redirect_to(post_path(comment.commentable))
    end

    it "should be long comment if length > 140" do
      request.env["HTTP_REFERER"] = post_path(comment.commentable)
      expect{
        post :create, post_id:comment.commentable, comment:{content: 'A' * 150}, format:'js'
      }.to change(Comment, :count).by(1)
      expect(assigns(:comment).is_long?).to  be_true
      expect(response).to redirect_to(post_path(comment.commentable))
    end

    it "should be invalid if length > 3000" do
      request.env["HTTP_REFERER"] = post_path(comment.commentable)
      expect{
        post :create, post_id:comment.commentable, comment:{content: 'A' * 3001 }, format:'js'
      }.to change(Comment, :count).by(0)

      assigns(:comment).errors.empty?.should_not be_true
      assigns(:comment).errors[:content].empty?.should_not be_true

      assigns(:comment).errors[:content].first.should match(/过长/)
      expect(response).to redirect_to(post_path(comment.commentable))
    end
  end

end
