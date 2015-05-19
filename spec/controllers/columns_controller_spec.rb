require 'spec_helper'

describe ColumnsController do

  describe "GET 'show'" do
    let(:post) { create(:post, :published) }

    context 'html' do
      before{ get :show, slug: post.column.slug }
      it 'returns http success' do
        response.should be_success
      end
    end

    context "html fragment" do 
      before { xhr :get, :show, slug: post.column.slug, d: 'next', b_url_code: (post.url_code + 1), format: :html}
      it do
        should respond_with(:success)
        should render_template(:partial => 'columns/_list')
      end
    end

    context 'json' do
      before { xhr :get, :show, slug: post.column.slug, page: 2, format: :json}
      it do
        should respond_with(:success)
        expect(response.headers['Content-Type']).to include 'application/json'
      end
    end
  end
end
