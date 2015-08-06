require 'spec_helper'

describe ColumnsController do

  describe "GET 'show'" do

    context 'html' do
      let(:post) { create(:post, :published) }
      before{ get :show, slug: post.column.slug }
      it 'returns http success' do
        response.should be_success
      end
    end

    context 'with newsflashes' do
      let(:column){ create(:column) }
      before{
        create :newsflash, :newsflash_data, column: column
        get :show, slug: column.slug
      }
      it 'without post' do
        response.should be_success
        should render_template(:partial => 'columns/_posts_with_newsflashes')
      end

      it 'with post' do
        create(:post, :published, column: column)
        response.should be_success
        should render_template(:partial => 'columns/_posts_with_newsflashes')
      end
    end

    context "html fragment" do 
      let(:post) { create(:post, :published) }
      before { xhr :get, :show, slug: post.column.slug, d: 'next', b_url_code: (post.url_code + 1), format: :html}
      it do
        should respond_with(:success)
        should render_template(:partial => 'columns/_list')
      end
    end

    context 'json' do
      let(:post) { create(:post, :published) }
      before { xhr :get, :show, slug: post.column.slug, d: 'next', b_url_code: (post.url_code + 1), format: :json}
      it do
        should respond_with(:success)
        expect(response.headers['Content-Type']).to include 'application/json'
      end
    end
  end
end
