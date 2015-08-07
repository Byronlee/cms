require 'spec_helper'

describe Admin::NewsflashesController do
  login_admin_user

  describe "GET 'index'" do
    before { create :newsflash }
    it "returns http success" do
      @newsflash = build :newsflash
      @newsflash.tag_list = '_newsflash'
      @newsflash.save
      get 'index', ptype: '_newsflash'
      expect(assigns(:newsflashes)).to eq [Newsflash.tagged_with('_newsflash').first]
      response.should be_success
    end

    it "if ptype note included in params should return back" do
      request.env["HTTP_REFERER"] = admin_newsflashes_path
      get 'index'
      expect(response).to redirect_to(admin_newsflashes_path)
    end
  end

  describe "patch 'update'" do
    let(:newsflash) { create :newsflash }

    it "returns http success" do
      patch :update, id: newsflash.id, newsflash: attributes_for(:newsflash).merge(tag_list: '_newsflash')
      expect(response.status).to eq 302
    end
  end

  describe "post 'create'" do
    it "returns http success" do
      expect do
        post :create, newsflash: attributes_for(:newsflash).merge(tag_list: '_newsflash')
      end.to change(Newsflash, :count).by(1)
    end
  end

  describe "DELETE 'destroy'" do
    before { create :newsflash }

    it "returns http success" do
      request.env["HTTP_REFERER"] = admin_newsflashes_path
      expect do
        delete :destroy, id: Newsflash.first.id
      end.to change(Newsflash, :count).by(-1)
      expect(response).to redirect_to(admin_newsflashes_path)
    end
  end

  describe "PATCH 'set_top'" do
    let!(:newsflash) { create :newsflash }

    it "returns http success" do
      request.env["HTTP_REFERER"] = admin_newsflashes_path
      patch :set_top, id: newsflash.id
      expect(newsflash.reload.is_top?).to eq true
      expect(newsflash.reload.toped_at.present?).to eq true
      expect(response).to redirect_to(admin_newsflashes_path)
    end
  end

  describe "PATCH 'set_top'" do
    let!(:newsflash) { create :newsflash }

    it "returns http success" do
      request.env["HTTP_REFERER"] = admin_newsflashes_path
      patch :set_down, id: newsflash.id
      expect(newsflash.reload.is_top?).to eq false
      expect(newsflash.reload.toped_at.present?).to eq false
      expect(response).to redirect_to(admin_newsflashes_path)
    end
  end
end
