require 'spec_helper'

describe Admin::FragmentTemplatesController do
  login_admin_user

  describe "GET 'index'" do
    before { create :fragment_template }
    it "returns http success" do
      get 'index'
      expect(assigns(:fragment_templates)).to eq [FragmentTemplate.first]
      response.should be_success
    end
  end

  describe "patch 'update'" do
    let(:fragment_template) { create :fragment_template }

    it "returns http success" do
      patch :update, id: fragment_template.id, fragment_template: attributes_for(:fragment_template)
      expect(response.status).to eq 302
    end
  end

  describe "post 'create'" do
    it "returns http success" do
      expect do
        post :create, fragment_template: attributes_for(:fragment_template)
      end.to change(FragmentTemplate, :count).by(1)
    end
  end

  describe "DELETE 'destroy'" do
    before { create :fragment_template }

    it "returns http success" do
      request.env["HTTP_REFERER"] = admin_fragment_templates_path
      expect do
        delete :destroy, id: FragmentTemplate.first.id
      end.to change(FragmentTemplate, :count).by(-1)
      expect(response).to redirect_to(admin_fragment_templates_path)
    end
  end
end
