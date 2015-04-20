require 'spec_helper'

describe Components::PagesController do
  describe "GET 'show'" do
    let(:page) { create :page }

    it 'return http success and return page json' do
      get :show, id: page.id
      response.should be_success
      expect(assigns(:page)).to eq page
      expect(response.header['Content-Type']).to eq('application/json; charset=utf-8')
    end
  end
end
