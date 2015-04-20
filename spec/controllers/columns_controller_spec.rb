require 'spec_helper'

describe ColumnsController do

  describe "GET 'show'" do
    let(:post) { create(:post, :published) }
    it 'returns http success' do
      get 'show', slug: post.column.slug
      response.should be_success
    end
  end
end
