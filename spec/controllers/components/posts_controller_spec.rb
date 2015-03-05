require 'spec_helper'

describe Components::PostsController do

  describe "GET 'today_lastest'" do
    it "returns http success" do
      get 'today_lastest'
      response.should be_success
    end
  end

end
