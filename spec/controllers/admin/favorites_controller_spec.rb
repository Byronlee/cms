require 'spec_helper'

describe Admin::FavoritesController do
  login_admin_user

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end
end
