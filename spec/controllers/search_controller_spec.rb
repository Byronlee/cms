require "spec_helper"

describe SearchController do
  describe "GET 'search'" do
    before { Post.index.delete; Post.create_elasticsearch_index }

    context "all posts" do
      before { get :search, q: "" }
      it { should respond_with(:success) }
    end
    context "with results" do
      let!(:old_post) { create :post, :published, title: "标题1", published_at: 1.hour.ago }
      let!(:new_post) { create :post, :published, title: "标题2", published_at: 1.minute.ago }
      before { Post.index.refresh }
      before { get :search, q: "标题" }
      it {
        should respond_with(:success)
        expect(assigns[:posts].first).to eq(new_post)
      }
    end
    context "not result" do
      before { get :search, q: "oo-1xx" }
      it { should respond_with(:success) }
    end
  end
end