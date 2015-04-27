require 'spec_helper'

describe Admin::PostsController do
  login_admin_user

  describe "GET 'index'" do
    before do
      @post = create :post, :published
    end

    it "returns http success" do
      get 'index'
      response.should be_success
      expect(response).to render_template('admin/posts/index')
      expect(assigns(:posts)).to eq [@post]
    end

    it "returns http success when column id present" do
      get 'index', column_id: @post.column.id
      response.should be_success
      expect(response).to render_template('admin/posts/index')
      expect(assigns(:posts)).to eq [@post]
    end
  end

  describe "GET 'reviewing'" do
    before do
      @post = create :post, :reviewing
    end

    it "returns http success" do
      get 'reviewings'
      response.should be_success
      expect(response).to render_template('admin/posts/reviewings')
      expect(assigns(:posts)).to eq [@post]
    end

    it "returns http success when column id present" do
      get 'reviewings', column_id: @post.column.id
      response.should be_success
      expect(response).to render_template('admin/posts/reviewings')
      expect(assigns(:posts)).to eq [@post]
    end
  end

  describe "GET 'myown'" do
    before do
      @author = User.where(role: 'admin').first
      @post1 = create :post, :published, author: @author
      @post2 = create :post, :reviewing, author: @author
    end

    it "returns http success" do
      get 'myown'
      response.should be_success
      expect(response).to render_template('admin/posts/myown')
      expect(assigns(:posts).map(&:author)).to eq [@author, @author]
    end

    it "returns http success when column id present" do
      get 'myown', column_id: @post1.column.id
      response.should be_success
      expect(response).to render_template('admin/posts/myown')
      expect(assigns(:posts).map(&:author)).to eq [@author, @author]
    end
  end

  describe "GET 'draft'" do
    before do
      @author = User.where(role: 'admin').first
      @post = create :post, :draft, author: @author
    end

    it "returns http success" do
      get 'draft'
      response.should be_success
      expect(response).to render_template('admin/posts/draft')
      expect(assigns(:posts)).to eq [@post]
    end

    it "returns http success when column id present" do
      get 'draft', column_id: @post.column.id
      response.should be_success
      expect(response).to render_template('admin/posts/draft')
      expect(assigns(:posts)).to eq [@post]
    end
  end

  describe "patch 'update'" do
    let(:post) { create :post, :published }

    it "returns http success" do
      patch :update, id: post.id, post: attributes_for(:post)
      expect(response.status).to eq 302
    end
  end

  describe "get 'show'" do
    let(:post) { create :post, :published }

    it "returns http success" do
      get :show, id: post.id
      response.should be_success
      expect(response).to render_template('admin/posts/show')
    end
  end

  describe "DELETE 'destroy'" do
    before { create :post }

    it "returns http success" do
      request.env["HTTP_REFERER"] = admin_posts_path
      expect do
        delete :destroy, id: Post.first.id
      end.to change(Post, :count).by(-1)
      expect(response).to redirect_to(admin_posts_path)
    end
  end

  describe "post 'do_publish'" do
    it "suport update post(not publish)" do
      p_post = create :post, :reviewing
      post :do_publish, id: p_post.id, post: attributes_for(:post)
      expect(p_post.reviewing?).to be true
      expect(response).to redirect_to(reviewings_admin_posts_path)
    end

    it "published post cannot publish, return http false" do
      p_post = create :post, :published
      post :do_publish, id: p_post.id, operate_type: 'publish', post: attributes_for(:post)
      expect(response).to redirect_to reviewings_admin_posts_path
    end

    it "draft post can publish, return http true" do
      p_post = create :post, :draft
      post :do_publish, id: p_post.id, operate_type: 'publish', post: attributes_for(:post)
      expect(response).to redirect_to reviewings_admin_posts_path
    end

    it 'reviewing post can correct publish' do
      p_post = create :post, :reviewing
      post :do_publish, id: p_post.id, operate_type: 'publish', post: attributes_for(:post)
      expect(assigns(:post).published?).to be true
      expect(response).to redirect_to(reviewings_admin_posts_path)
    end

    it 'publish post with will_publish_at' do
      p_post = create :post, :reviewing
      post :do_publish, id: p_post.id, operate_type: 'publish', post: attributes_for(:post).merge(will_publish_at: 5.seconds.from_now)
      expect(assigns(:post).published?).to be false
      expect(assigns(:post).will_publish_at).not_to eq ''
      expect(assigns(:post).jid).not_to eq ''
      expect(response).to redirect_to(reviewings_admin_posts_path)
    end

    it 'update will_publish_at' do
      p_post = create :post, :reviewing
      post :do_publish, id: p_post.id, operate_type: 'publish', post: attributes_for(:post).merge(will_publish_at: 10.seconds.from_now)
      jid = assigns(:post).jid
      post :do_publish, id: p_post.id, operate_type: 'publish', post: attributes_for(:post).merge(will_publish_at: 5.seconds.from_now)
      expect(assigns(:post).jid).not_to eq jid
    end
  end

  describe "GET 'draft'" do
    let!(:comment) { create(:post, :drafted) }

    context "contributor can access draft page" do
      login_user :contributor

      before { get 'draft' }
      it do
        should respond_with(:success)
        should render_template(:draft)
      end
    end
  end

  describe "post 'undo_publish'" do
    it "reviewing post cannot undo_publish, return http false" do
      p_post = create :post, :reviewing
      expect do
        post :undo_publish, id: p_post.id
      end.to raise_error(AASM::InvalidTransition)
    end

    it "draft post cannot undo_publish, return http false" do
      p_post = create :post, :draft
      expect do
        post :undo_publish, id: p_post.id
      end.to raise_error(AASM::InvalidTransition)
    end

    it 'published post can correct undo_publish' do
      request.env["HTTP_REFERER"] = reviewings_admin_posts_path
      p_post = create :post, :published
      post :undo_publish, id: p_post.id
      expect(assigns(:post).reviewing?).to be true
      expect(response).to redirect_to(reviewings_admin_posts_path)
    end
  end

  describe 'published post cannot vist publish action' do
    it do
      p_post = create :post, :published
      get :publish, id: p_post.id
      expect(response).to redirect_to edit_admin_post_url(p_post)
    end
  end

  describe 'not published post cannot vist edit action' do
    it do
      p_post = create :post, :reviewing
      get :edit, id: p_post.id
      expect(response).to redirect_to publish_admin_post_path(p_post)
    end
  end

  describe "post 'toggle_tag'" do
    before do
      @post = create :post, :published
    end

    it "post tag not include bdnews, return include" do
      request.env["HTTP_REFERER"] = reviewings_admin_posts_path
      post :toggle_tag, id: @post.id
      expect(assigns(:post).reload.bdnews?).to be true
      expect(response).to redirect_to(reviewings_admin_posts_path)
    end

    it "post tag include bdnews, return not include" do
      request.env["HTTP_REFERER"] = reviewings_admin_posts_path
      @post.tag_list = 'bdnews'
      @post.save
      post :toggle_tag, id: @post.id
      expect(assigns(:post).reload.bdnews?).to be false
      expect(response).to redirect_to(reviewings_admin_posts_path)
    end
  end
end
