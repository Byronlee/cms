require 'spec_helper'

describe PostsController do

  describe "GET 'show'" do
    context 'without login' do
      let (:post) { create(:post, :published) }
      before { get 'show', url_code: post.url_code }
      it {
        should respond_with(:success)
        should render_template(:show)

        post = assigns(:post)
        expect(post.cache_views_count - post.views_count).to eq(1)
        expect(post.persist_views_count).to eq([post.cache_views_count, post.views_count].max)
        expect(post.cache_views_count - post.views_count).to eq(0)
      }
    end
  end

end
