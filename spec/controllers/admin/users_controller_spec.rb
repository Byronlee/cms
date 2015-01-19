require 'spec_helper'

describe Admin::UsersController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
      expect(response).to render_template(:admin)
    end
  end

end
