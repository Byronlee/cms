require 'spec_helper'

describe Components::CommentsController do

  describe "GET 'index'" do
     it "return http success and return the excellent comemnts" do
      get 'index'
      response.should be_success
      expect(response.header["Content-Type"]).to eq("application/json; charset=utf-8")
    end
  end

end
