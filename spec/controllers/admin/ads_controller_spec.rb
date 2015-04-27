require 'spec_helper'

describe Admin::AdsController do
  login_admin_user

  describe "GET 'index'" do
    let!(:ad) { create(:ad) }

    it "returns http success" do
      get 'index'
      response.should be_success
      expect(response).to render_template(:admin)
      expect(assigns(:ads)).to eq([ad])
    end
  end

  describe "PATCH 'update'" do
    context 'when params is valid' do
      let!(:ad) { create(:ad) }
      let(:position) { 4 }

      it "returns http rediect" do
        patch :update, id: ad, ad: { :position => position }
        expect(response.status).to eq(302)
        expect(ad.reload.position).to eq position
        expect(response).to redirect_to(admin_ads_path)
      end
    end

    context "when params is invalid" do
      let!(:ad) { create(:ad) }

      it "returns back for position and content being necessary" do
        patch :update, id: ad, ad: { :position => nil, :content => nil }
        assigns(:ad).errors.empty?.should_not be_true
        assigns(:ad).errors[:position].empty?.should_not be_true
        assigns(:ad).errors[:content].empty?.should_not be_true

        assigns(:ad).errors[:position].first.should match(/不能为空字符/)
        assigns(:ad).errors[:content].first.should match(/不能为空字符/)
      end

      it "returns back for position being uniquee" do
        ad2 = create(:ad)
        patch :update, id: ad, ad: { :position => ad2.position }
        assigns(:ad).errors.empty?.should_not be_true
        assigns(:ad).errors[:position].empty?.should_not be_true
        assigns(:ad).errors[:content].empty?.should be_true

        assigns(:ad).errors[:position].first.should match(/已经被使/)
      end
    end
  end

  describe "POST 'create'" do
    context "when params is valid" do
      it "returns http rediect" do
        expect do
          post 'create', :ad => attributes_for(:ad)
        end.to change(Ad, :count).by(1)
        expect(response.status).to eq(302)
        expect(response).to redirect_to(admin_ads_path)
      end
    end

    context "when params is invalid" do
      it "returns back for url being necessary" do
        post 'create', :ad => { :position => nil, :content => nil }
        assigns(:ad).errors.empty?.should_not be_true
        assigns(:ad).errors[:position].empty?.should_not be_true
        assigns(:ad).errors[:content].empty?.should_not be_true

        assigns(:ad).errors[:position].first.should match(/不能为空字符/)
        assigns(:ad).errors[:content].first.should match(/不能为空字符/)
      end

      it "returns back for url being uniquee" do
        ad = create :ad
        post 'create', :ad => {:position => ad.position, :content => 'new content'}
        assigns(:ad).errors.empty?.should_not be_true
        assigns(:ad).errors[:position].empty?.should_not be_true
        assigns(:ad).errors[:content].empty?.should be_true

        assigns(:ad).errors[:position].first.should match(/已经被使用/)
      end
    end
  end

  describe "DELETE 'destroy'" do
    before { @ad = create :ad }
    it "returns http rediect" do
      request.env["HTTP_REFERER"] = admin_ads_path
      expect do
        delete :destroy, :id => @ad
      end.to change(Ad, :count).by(-1)
      expect(response).to redirect_to(admin_ads_path)
    end
  end
end
