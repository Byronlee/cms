require 'spec_helper'

describe Admin::ToolsController do

  describe "GET 'redis'" do
    it "returns http success" do
      get 'redis'
      response.should be_success
    end
  end

end
