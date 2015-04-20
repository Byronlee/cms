require "spec_helper"

describe API::API do
  include ApiHelpers

#   describe "GET /api/v1/posts/index.json" do
#     it "should return an array of posts" do
#       get "/api/v1/posts/index.json"
#       response.status.should == 200
#       json_response.should be_an Array
#     end
#   end

#   describe "GET /api/v1/posts/:id/page.json" do
#     it "should return an down array of posts" do
#       get "/api/v1/posts/1/page.json?state=draft"
#       response.status.should == 404
#     end
#   end

#   describe "GET /api/v1/posts/:id" do
#   let(:post) { create(:post) }
#     it "should return a post by id" do
#       get "/api/v1/posts/#{post.id}.json"
#       response.status.should == 200
#       json_response['title'].should == post.title
#     end
#   end

# #  describe "PUT 'update' /api/v1/posts/:id" do
# #  let(:post) { create(:post) }
# #    it "should return a post by id" do
# #      put "/api/v1/posts/#{post.id}.json?title=patch"
# #      response.status.should == 200
# #      json_response['title'].should == 'patch'
# #    end
# #  end

#   describe "DELETE /api/v1/posts/:id" do
#   let(:post) { create(:post) }
#     it "should return a post by id" do
#       delete "/api/v1/posts/#{post.id}.json"
#       response.status.should == 200
#     end
#   end

#   describe "GET /api/v1/posts" do
#   let(:post) { create(:post) }
#     it "returns an empty array of statuses" do
#       post = create :post
#       get "/api/v1/posts/index", state: post.state
#       expect(response.status).to eq(200)
#     end
#   end

#   describe "POST /api/v1/posts/new" do
#     it "returns an a new post" do
#       post "/api/v1/posts/new", attributes_for(:post)
#       expect(response.status).to eq(201)
#       #expect(response.body).to eq [post.to_json]
#     end
#   end

#   describe "GET /api/v1/posts/:id" do
#     it "returns an a  post" do
#       post = create :post
#       get "/api/v1/posts/"+post.id.to_s
#       expect(response.status).to eq(200)
#       #expect(response.body).to eq [post.to_json]
#     end
#   end
end
