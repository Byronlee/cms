require 'spec_helper'

describe Admin::FavoritesController do
  login_admin_user

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "DELETE 'destroy'" do
    before do
      @favorite = create :favorite
    end

    it "returns http success" do
      request.env["HTTP_REFERER"] = admin_pages_path
      expect do
        delete :destroy, id: @favorite.id
      end.to change(Favorite, :count).by(-1)
      expect(response).to redirect_to(admin_pages_path)
    end
  end
end
