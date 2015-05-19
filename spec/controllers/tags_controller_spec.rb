require 'spec_helper'

describe TagsController do
  describe "GET 'show'" do
    let!(:post) do 
      post = create :post, :published 
      post.tag_list = 'fuck'
      post.save
      post
    end

    context 'html' do
      before do
        get :show, tag: 'fuck'
      end

      it 'returns http success' do
        response.should be_success
        expect(assigns(:posts)).to eq [post]
      end
    end

    context 'tag not found' do
      it 'raise ActiveRecord::RecordNotFound' do
        expect {
          get :show, tag: 'oo-xx'
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context "html fragment" do 
      before { xhr :get, :show, tag: 'fuck', d: 'next', b_url_code: (post.url_code + 1), format: :html }
      it do
        should respond_with(:success)
        should render_template(:partial => 'tags/_list')
      end
    end

    context 'json' do
      before { xhr :get, :show, tag: 'fuck', d: 'next', b_url_code: (post.url_code + 1), format: :json }
      it do
        should respond_with(:success)
        expect(response.headers['Content-Type']).to include 'application/json'
      end
    end
  end
end
