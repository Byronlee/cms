require 'spec_helper'

describe SearchController do
  describe "GET 'search'" do
    before do
      Post.index.delete
      Post.create_elasticsearch_index
    end
    let!(:old_post) { create :post, :published, title: '标题1', published_at: 1.hour.ago }
    let!(:new_post) { create :post, :published, title: '标题2', published_at: 1.minute.ago }

    context 'all posts' do
      before { create :post, :published, title: '标题1', published_at: 1.hour.ago }
      before { get :search, q: '' }
      it { should respond_with(:success) }
    end

    context 'with results' do
      before { Post.index.refresh }
      before { get :search, q: '标题' }
      it do
        should respond_with(:success)
        expect(assigns[:posts].first).to eq(new_post)
      end
    end
    context 'not result' do
      before { create :post, :published, title: 'oo-1xx', published_at: 1.hour.ago }
      before { get :search, q: 'oo-1xx' }
      it { should respond_with(:success) }
    end

    context "html fragment" do 
      before { xhr :get, :search, q: '标题', d: 'next', b_url_code: (old_post.url_code + 1), format: :html }
      it do
        should respond_with(:success)
        should render_template(:partial => 'search/_list')
      end
    end

    context 'json' do
      before { xhr :get, :search, q: '标题', d: 'next', b_url_code: (old_post.url_code + 1), format: :json }
      it do
        should respond_with(:success)
        expect(response.headers['Content-Type']).to include 'application/json'
      end
    end
  end
end
