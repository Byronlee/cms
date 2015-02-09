require 'spec_helper'

describe PostsController do

  describe "GET 'show'" do
    let!(:post){ create(:post) }
    it "returns http success" do
      get 'show', id:post
      response.should be_success
    end
  end

end
