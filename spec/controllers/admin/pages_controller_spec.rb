require 'spec_helper'

describe Admin::PagesController do
  login_admin_user

  describe "GET 'index'" do
    before { create :page }
    it "returns http success" do
      get 'index'
      expect(assigns(:pages)).to eq [Page.first]
      response.should be_success
    end
  end

  describe "patch 'update'" do
    let(:page) { create :page }

    it "returns http success" do
      patch :update, id: page.id, page: attributes_for(:page)
      expect(response.status).to eq 302
    end
  end

  describe "post 'create'" do
    it "returns http success" do
      expect do
        post :create, page: attributes_for(:page)
      end.to change(Page, :count).by(1)
    end
  end

  describe "DELETE 'destroy'" do
    before { create :page }

    it "returns http success" do
      request.env["HTTP_REFERER"] = admin_pages_path
      expect do
        delete :destroy, id: Page.first.id
      end.to change(Page, :count).by(-1)
      expect(response).to redirect_to(admin_pages_path)
    end
  end
end
