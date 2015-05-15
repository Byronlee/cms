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

  describe "GET 'hire'" do
    it 'returns http success' do
      get 'hire'
      response.should be_success
    end
  end
end
