require 'spec_helper'

describe PostsController do
  include Rails.application.routes.url_helpers
  login_user

  describe "GET 'show'" do
    context 'html' do
      let(:post) { create(:post, :published) }
      before { get 'show', url_code: post.url_code }
      it do
        should respond_with(:success)
        should render_template(:show)

        post = assigns(:post)
        expect(post.cache_views_count - post.views_count).to eq(1)
        expect(post.persist_views_count).to eq([post.cache_views_count, post.views_count].max)
        expect(post.cache_views_count - post.views_count).to eq(0)
      end
    end
  end

  describe "GET 'preview'" do
    context 'html' do
      let(:post) { create(:post, :reviewing) }
      before { get 'preview', key: post.key }
      it do
        should respond_with(:success)
        should render_template(:show)
      end
    end
  end
end
