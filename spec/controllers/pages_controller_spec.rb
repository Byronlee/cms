require 'spec_helper'

describe PagesController do

  describe "GET 'show'" do
    let(:page) { create :page }

    it 'returns http success' do
      get 'show', slug: page.slug
      response.should be_success
      expect(assigns(:page)).to eq page
    end
  end
end
