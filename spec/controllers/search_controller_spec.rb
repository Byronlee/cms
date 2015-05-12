require 'spec_helper'

describe SearchController do
  describe "GET 'search'" do
    before do
      Post.index.delete
      Post.create_elasticsearch_index
    end

    context 'all posts' do
      before { create :post, :published, title: '标题1', published_at: 1.hour.ago }
      before { get :search, q: '' }
      it { should respond_with(:success) }
    end

    context 'with results' do
      let!(:old_post) { create :post, :published, title: 'title 1', published_at: 1.hour.ago }
      let!(:new_post) { create :post, :published, title: 'title 2', published_at: 1.minute.ago }
      before { Post.index.refresh }
      before { get :search, q: 'title' }
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
  end
end
