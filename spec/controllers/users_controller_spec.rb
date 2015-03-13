require 'spec_helper'

describe UsersController do

  describe "GET 'messages'" do
    it "returns http success" do
      get 'messages'
      response.should be_success
    end
  end

end
