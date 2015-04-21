require 'spec_helper'

describe SearchController do
  describe "GET 'search'" do
    before do
      Post.index.delete
      Post.create_elasticsearch_index
    end

    context 'all posts' do
      before { get '/api/v2/search.json??q=a&page=1&per_page=30&api_key=501Cd1AvUL4AxxVEX60gCFJK7HCd9y8ySDvG29Je' }
      it { response.status.should == 200 }
    end

    context 'with results' do
      let!(:old_post) { create :post, :published, title: '标题1', published_at: 1.hour.ago }
      let!(:new_post) { create :post, :published, title: '标题2', published_at: 1.minute.ago }
      before { Post.index.refresh }
      before { get '/api/v2/search.json??q=a&page=1&per_page=30&api_key=501Cd1AvUL4AxxVEX60gCFJK7HCd9y8ySDvG29Je', q: '标题' }
      it do
        response.status.should == 200
      end
    end
    context 'not result' do
      before { get '/api/v2/search.json??q=a&page=1&per_page=30&api_key=501Cd1AvUL4AxxVEX60gCFJK7HCd9y8ySDvG29Je', q: 'xxoo' }
      it { response.status.should == 200 }
    end
  end
end
