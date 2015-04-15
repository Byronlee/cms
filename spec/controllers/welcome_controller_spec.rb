require 'spec_helper'

describe WelcomeController do
  describe "GET 'index'" do
    context 'read cache index' do
      before { get :index }
      it do
        expect(response).to be_success
        expect(assigns(:next_page)).to eq 2
      end
    end
  end

  describe "GET 'index'" do
    context 'read database index' do
      before :each do
        create :post, :published
        create :main_site
      end

      it do
        get :index, page: 2
        expect(response).to be_success
        expect(assigns(:prev_page)).to eq 1
      end
    end
  end

  describe "GET 'changes'" do
    before { get :changes}
    it { should respond_with(:success) }
  end
end
