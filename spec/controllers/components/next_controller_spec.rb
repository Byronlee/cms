require 'spec_helper'

describe Components::NextController do

  describe "GET 'collections'" do
    it "return http success and return the next collections" do
      get 'collections'
      response.should be_success
    end
  end

end
