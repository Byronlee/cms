require 'spec_helper'

describe Components::HeadLinesController do

  describe "GET 'collections'" do
    it "return http success and return the next collections" do
      get 'index'
      response.should be_success
      expect(response.header["Content-Type"]).to eq("application/json; charset=utf-8")
    end
  end

end
