require 'spec_helper'

describe Admin::InfoFlowsController do
  login_admin_user

  describe "GET 'index'" do
    let!(:info_flow) { create(:info_flow) }

    it "returns http success" do
      get 'index'
      response.should be_success
      expect(response).to render_template(:admin)
      expect(assigns(:info_flows)).to eq([info_flow])
    end
  end

  describe "PATCH 'update'" do
    context "when params is valid" do
      let!(:info_flow) { create(:info_flow) }
      let(:name) { 'new name' }

      it "returns http rediect" do
        patch :update, id: info_flow, info_flow: { :name => name }
        expect(response.status).to eq(302)
        expect(info_flow.reload.name).to eq name
        expect(response).to redirect_to(admin_info_flows_path)
      end
    end

    context "when params is invalid" do
      let!(:info_flow) { create(:info_flow) }

      it "returns back for name being necessary" do
        patch :update, id: info_flow, info_flow: { :name => nil }
        assigns(:info_flow).errors.empty?.should_not be_true
        assigns(:info_flow).errors[:name].empty?.should_not be_true

        assigns(:info_flow).errors[:name].first.should match(/不能为空字符/)
      end

      it "returns back for name being uniquee" do
        create :info_flow2
        patch :update, id: info_flow, info_flow: { :name => attributes_for(:info_flow2)[:name]  }
        assigns(:info_flow).errors.empty?.should_not be_true
        assigns(:info_flow).errors[:name].empty?.should_not be_true

        assigns(:info_flow).errors[:name].first.should match(/已经被使/)
      end
    end
  end

  describe "POST 'create'" do
    context "when params is valid" do
      it "returns http rediect" do
        expect do
          post 'create', :info_flow => attributes_for(:info_flow2)
        end.to change(InfoFlow, :count).by(1)
        expect(response.status).to eq(302)
        expect(response).to redirect_to(admin_info_flows_path)
      end
    end

    context "when params is invalid" do
      it "returns back for url being necessary" do
        post 'create', :info_flow => { :name => nil }
        assigns(:info_flow).errors.empty?.should_not be_true
        assigns(:info_flow).errors[:name].empty?.should_not be_true

        assigns(:info_flow).errors[:name].first.should match(/不能为空字符/)
      end

      it "returns back for url being uniquee" do
        create :info_flow2
        post 'create', :info_flow => attributes_for(:info_flow2)
        assigns(:info_flow).errors.empty?.should_not be_true
        assigns(:info_flow).errors[:name].empty?.should_not be_true

        assigns(:info_flow).errors[:name].first.should match(/已经被使用/)
      end
    end
  end

  describe "DELETE 'destroy'" do
    before { @info_flow = create :info_flow }
    it "returns http rediect" do
      request.env["HTTP_REFERER"] = admin_info_flows_path # for redicect :back
      expect do
        delete :destroy, :id => @info_flow
      end.to change(InfoFlow, :count).by(-1)
      expect(response).to redirect_to(admin_info_flows_path)
    end
  end
end
