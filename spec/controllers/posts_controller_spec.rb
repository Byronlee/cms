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

    context 'with source type of translation' do
      let(:post) { create(:post, :published, :translation) }
      before { get 'show', url_code: post.url_code }
      it do
        should respond_with(:success)
        should render_template(:show)

        post = assigns(:post)
        expect(post.source_urls_array).to eq(['http://36kr.com', 'http://www.google.com'])
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

  describe "GET 'archives'" do
    before :each do
      create :post, :published
    end

    it do
      get :archives, :year => Date.today.year
      expect(response).to be_success
      expect(assigns(:posts).length).to eq 1
    end

    it do
      get :archives, :year => Date.today.year, :month => Date.today.month
      expect(response).to be_success
      expect(assigns(:posts).length).to eq 1
    end

    it do
      get :archives, :year => Date.today.year, :month => Date.today.month, :day => Date.today.day
      expect(response).to be_success
      expect(assigns(:posts).length).to eq 1
    end
  end

  describe "GET 'feed'" do
    context 'rss' do
      it do
        post = create :post, :published
        get 'feed', :format => :rss
        expect(assigns(:feeds)).to eq [post]
        should respond_with(:success)
      end
    end
  end

  describe "GET 'baidu_feed'" do
    context 'rss' do
      it do
        post = create :post, :published
        get 'baidu_feed', :format => :rss
        should respond_with(:success)
      end
    end
  end

  describe "GET 'feed_bdnews'" do
    context 'rss' do
      let(:post) { create(:post, :published) }
      before do
        post.tag_list = 'bdnews'
        post.save
        get 'feed_bdnews', :format => :rss
      end
      it do
        should respond_with(:success)
        expect(assigns(:feeds)).to eq [post]
        expect(response.headers['content-type']).to eq 'application/xml'
      end
    end
  end

  describe "GET 'bdnews'" do
    let(:post) { create(:post, :published) }
    before do
      post.tag_list = 'bdnews'
      post.save
      get "bdnews", url_code: post.url_code
    end
    it do
      should respond_with(:success)
      expect(assigns(:post)).to eq post
    end
  end

  describe "GET 'partner_feed'" do
    context 'rss' do
      it do
        post = create :post, :published
        get :partner_feed, partner: 'liebao', :format => :rss
        expect(assigns(:feeds)).to eq [post]
        should respond_with(:success)
      end
    end
  end

  describe "GET 'baidu_feed'" do
    context 'rss' do
      it do
        post = create :post, :published
        get :baidu_feed, :format => :rss
        expect(assigns(:feeds)).to eq [post]
        should respond_with(:success)
      end
    end
  end

  describe "GET 'xiaozhi_feed'" do
    context 'rss' do
      it do
        post = create :post, :published
        get :xiaozhi_feed, :format => :rss
        expect(assigns(:feeds)).to eq [post]
        should respond_with(:success)
      end
    end
  end

  describe "GET 'chouti_feed'" do
    context 'rss' do
      it do
        post = create :post, :published
        get :chouti_feed, :format => :rss
        expect(assigns(:feeds)).to eq [post]
        should respond_with(:success)
      end
    end
  end

  describe "GET 'uc_feed'" do
    context 'rss' do
      it do
        post = create :post, :published
        get :uc_feed, :format => :rss
        expect(assigns(:feeds)).to eq [post]
        should respond_with(:success)
      end
    end
  end

end
