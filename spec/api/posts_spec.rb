require "spec_helper"

describe API::API do
  include ApiHelpers
  include V1::Helpers

  describe "GET /api/v1/posts" do
    it "returns an empty array of statuses" do
      post = create :post
      get "/api/v1/posts/index.json", state: post.state
      expect(response.status).to eq(200)
      #expect(response.body).to eq [post.to_json]
    end
  end

  describe "POST /api/v1/posts/new" do
    it "returns an a new post" do
      post "/api/v1/posts/new", attributes_for :post
      expect(response.status).to eq(200)
      #expect(response.body).to eq [post.to_json]
    end
  end

  describe "GET /api/v1/posts/:id" do
    it "returns an a  post" do
      post = create :post
      get "/api/v1/posts/"+post.id.to_s
      expect(response.status).to eq(200)
      #expect(response.body).to eq [post.to_json]
    end
  end

end
