require 'spec_helper'

describe PagesController do

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', slug: attributes_for(:page)[:slug]
      response.should be_success
    end
  end

end
