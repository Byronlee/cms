require 'spec_helper'

describe Admin::NewsflashesController do
  login_admin_user

  describe "GET 'index'" do
    before { create :newsflash }
    it "returns http success" do
      get 'index'
      expect(assigns(:newsflashes)).to eq [Newsflash.first]
      response.should be_success
    end
  end

  describe "patch 'update'" do
    let(:newsflash) { create :newsflash }

    it "returns http success" do
      patch :update, id: newsflash.id, newsflash: attributes_for(:newsflash)
      expect(response.status).to eq 302
    end
  end

  describe "post 'create'" do
    it "returns http success" do
      expect do
        post :create, newsflash: attributes_for(:newsflash)
      end.to change(Newsflash, :count).by(1)
    end
  end

  describe "DELETE 'destroy'" do
    before { create :newsflash }

    it "returns http success" do
      request.env["HTTP_REFERER"] = admin_info_flows_path
      expect do
        delete :destroy, id: Newsflash.first.id
      end.to change(Newsflash, :count).by(-1)
      expect(response).to redirect_to(admin_info_flows_path)
    end
  end
end
