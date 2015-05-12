require 'spec_helper'

describe Admin::RelatedLinksController do
  login_admin_user

  describe "GET 'index'" do
    context "should returns http sucess" do
      let!(:post) { create :post_with_related_links }
      it do
        get :index, post_id: post.id
        response.should be_success
        expect(assigns(:related_links).count).to eq 5
        expect(assigns(:related_links).map(&:post_id).collect{|post_id| post_id == assigns(:post).id }.all?).to eq true
        expect(response).to render_template('admin/related_links/index')
      end
    end
  end

  describe "GET 'new'" do
    let!(:post) { create :post_with_related_links }
    it "returns http success" do
      get :new, post_id: post.id
      response.should be_success
      expect(response).to render_template('admin/related_links/new')
    end
  end

  describe "PATCH 'update'" do
    context "when params is valid" do
      let!(:post) { create :post_with_related_links }
      let(:url) { "http://www.baidu.com" }

      it "returns http rediect" do
        patch :update, post_id: post.id, id: post.related_links.first.id, related_link: { :url => url }
        expect(response.status).to eq(302)
        expect(post.related_links.first.reload.url).to eq url
        expect(response).to redirect_to(admin_post_related_links_path(post))
      end
    end

    context "when params is invalid" do
      let!(:post) { create :post_with_related_links }

      it "returns back for url being necessary" do
        patch :update, post_id: post.id, id: post.related_links.first.id, related_link: { :url => nil }
        expect(assigns(:related_link).errors.empty?).to be_false
        expect(assigns(:related_link).errors[:url].empty?).to be_false

        expect(assigns(:related_link).errors[:url].first).to match(/不能为空字符/)
      end

      it "returns back for url being uniquee" do
        patch :update, post_id: post.id, id: post.related_links.first.id, related_link: { :url => post.related_links[2].url }
        expect(assigns(:related_link).errors.empty?).to be_false
        expect(assigns(:related_link).errors[:url].empty?).to be_false

        expect(assigns(:related_link).errors[:url].first).to match(/已经被使/)
      end
    end
  end

  describe "GET 'edit'" do
    let!(:post) { create :post_with_related_links }
    it "returns http success" do
      get :edit, post_id: post.id, id: post.related_links.first.id
      response.should be_success
    end
  end

  describe "POST 'create'" do
    let!(:post_obj) { create :post_with_related_links }

    context "when params is valid" do
      it "returns http rediect" do
        post :create, post_id: post_obj.id, :related_link => attributes_for(:related_link)
        expect(response.status).to eq(302)
        expect(response).to redirect_to(admin_post_related_links_path(post_obj))
      end
    end

    context "when params is invalid" do
      it "returns back for url being necessary" do
        post 'create', post_id: post_obj.id, :related_link => { :url => nil }
        expect(assigns(:related_link).errors.empty?).to be_false
        expect(assigns(:related_link).errors[:url].empty?).to be_false

        expect(assigns(:related_link).errors[:url].first).to match(/不能为空字符/)
      end

      it "returns back for url being uniquee" do
        post 'create', post_id: post_obj.id, :related_link => { url: post_obj.related_links.first.url}
        expect(assigns(:related_link).errors.empty?).to be_false
        expect(assigns(:related_link).errors[:url].empty?).to be_false

        expect(assigns(:related_link).errors[:url].first).to match(/已经被使用/)
      end
    end
  end

  describe "DELETE 'destroy'" do
    let!(:post) { create :post_with_related_links }

    it "returns http rediect" do
      request.env["HTTP_REFERER"] = admin_post_related_links_path(post) # for redicect :back
      expect do
        delete :destroy, id: post.related_links.first.id, post_id: post.id
      end.to change(RelatedLink, :count).by(-1)
      expect(response).to redirect_to(admin_post_related_links_path(post))
    end
  end

end
