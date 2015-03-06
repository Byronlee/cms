require 'spec_helper'

describe ColumnsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    let!(:column){
      create(:column)
    }
    it "returns http success" do
      get 'show', slug:column.slug
      response.should be_success
    end
  end

end
