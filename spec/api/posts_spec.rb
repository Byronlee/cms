require "spec_helper"

describe API::API, "posts", :type => :request do
  include ApiHelpers
  include V1::Helpers

  let(:post) { create(:post) }

  describe "GET /api/v1/posts/index.json" do
    it "should return an array of posts" do
      get "/api/v1/posts/index.json"
      response.status.should == 200
      json_response.should be_an Array
    end
  end

  describe "GET /api/v1/posts/:id/page.json" do
    it "should return an down array of posts" do
      get "/api/v1/posts/1/page.json?state=draft"
      response.status.should == 404
    end
  end

  describe "GET /api/v1/posts/:id" do
    it "should return a post by id" do
      get "/api/v1/posts/#{post.id}.json"
      response.status.should == 200
      json_response['title'].should == post.title
    end
  end

  describe "PUT 'update' /api/v1/posts/:id" do
    it "should return a post by id" do
      put "/api/v1/posts/#{post.id}.json?title=patch"
      response.status.should == 200
      json_response['title'].should == 'patch'
    end
  end

  describe "DELETE /api/v1/posts/:id" do
    it "should return a post by id" do
      delete "/api/v1/posts/#{post.id}.json"
      response.status.should == 200
    end
  end

  describe 'POST /api/v1/posts' do
    let(:path) { '/api/v1/posts' }
    let(:attributes) { FactoryGirl.attributes_for(:post) }

    describe 'validations' do
      context 'when title not exist in params' do
        let(:attributes) { FactoryGirl.attributes_for(:post).except(:title) }
        it  do
          binding.pry
          post path, :summary=>"summary", :content=>"content", :title_link=>"title_link", :must_read=>"true", :state=>"draft"
          
          expect(response).not_to be_success
          expect(response.status).to eq(400)
        end
      end
    end

    it 'responds successfully' do
      post path, attributes

      expect(response).to be_success
      expect(response.status).to eq(201)
    end

    it 'creates a new Post' do
      expect {
        post path, attributes
      }.to change(Post, :count).by(1)
    end
  end


end
