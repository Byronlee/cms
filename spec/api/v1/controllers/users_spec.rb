require "spec_helper"

describe API::API, "users", :type => :request do
  include ApiHelpers

  # let(:user)  { create(:user) }

  # describe "GET /api/v1/users/:id" do
  #   it "should return a user by id" do
  #     get "/api/v1/users/#{user.id}.json"
  #     response.status.should == 200
  #     json_response['email'].should == user.email
  #   end

  #   it "should return a 404 error if user id not found" do
  #     get "/api/v1/users/9999"
  #     response.status.should == 404
  #   end
  # end
end
