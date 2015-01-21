require 'spec_helper'

describe Components::NextController do

  describe "GET 'collections'" do
    it "return http success and return the next collections" do
      get 'collections'
      response.should be_success
      expect(response.header["Content-Type"]).to eq("application/json; charset=utf-8")
    end
  end

end
