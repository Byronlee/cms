require 'spec_helper'

describe Components::InfoFlowsController do

   describe "GET 'index'" do
    it "return http success and return the json data" do
      create :main_site
      get 'index'
      response.should be_success
      expect(response.header["Content-Type"]).to eq("application/json; charset=utf-8")
    end
  end

end
