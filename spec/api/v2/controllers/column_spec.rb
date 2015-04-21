require 'spec_helper'

describe API::API do
  include ApiHelpers

  describe 'GET /api/v2/column/index.json' do
    it "should return an array of column" do
      get "/api/v2/columns/index.json?api_key=501Cd1AvUL4AxxVEX60gCFJK7HCd9y8ySDvG29Je"
      response.status.should == 200
      json_response.should be_an Array
    end
  end

  describe 'GET /api/v2/column/:id.json' do
    it "should return an array of column" do
      column = create :column
      get "/api/v2/columns/#{column.id}.json?api_key=501Cd1AvUL4AxxVEX60gCFJK7HCd9y8ySDvG29Je"
      response.status.should == 200
      json_response.should be_an Array
    end
  end

  describe 'GET /api/v2/column/:cid/page/:pid.json' do
    it "should return an array of column" do
      column = create :column
      post = create :post, url_code: 1 ,user_id: 1, state: 'published', published_at: Time.now
      post.column = column
      get "/api/v2/columns/#{column.id}/page/#{post.id}.json?api_key=501Cd1AvUL4AxxVEX60gCFJK7HCd9y8ySDvG29Je"
      response.status.should == 200
      json_response.should be_an Array
    end
  end

end
