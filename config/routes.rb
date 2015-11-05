require 'sidekiq/web'

# TODO路由测试

Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root 'welcome#index', defaults: { format: :html }
  get 'search', to: 'search#search'

  # TODO 所有的 only: [] 全部改成 namespace :users，去掉所有的 only, except
  resources :users, only: [] do
    get :messages, on: :collection
  end

  namespace :admin, path: '/krypton' do
    authenticate :user, lambda { |u| Ability.new(u, 'Admin').can? :manage, :sidekiq } do
      mount Sidekiq::Web => '/sidekiq'
    end
    root to: redirect('/krypton/dashboard')
    resources :dashboard, :pages
    resources :newsflashes do
      member do
        patch :set_top
        patch :set_down
      end
    end
    resources :users do
      member do
        put :speak
        put :shutup
      end
      resources :posts, only: [:index], on: :collection
    end
    resources :ads, :fragment_templates
    resources :sites do
      resources :columns, module: :sites do
        patch :update_order_nums, on: :collection
      end
    end
    resources :head_lines, except: [:show] do
      get :archives, on: :collection
      post :archive, on: :member
      post :publish, on: :member
    end
    resources :columns do
      resources :posts, only: [:index], on: :collection do
        get :reviewings, on: :collection
      end
    end
    namespace :posts do
      resources :columns
    end
    resources :posts do
      resources :comments, only: [:index], on: :collection
      resources :related_links
      get :reviewings, on: :collection
      get :myown, on: :collection
      get :draft, on: :collection
      get :publish, on: :member
      post :do_publish, on: :member
      post :undo_publish, on: :member
      post :toggle_tag, on: :member
    end
    resources :favorites
    resources :comments do
      member do
        post :set_excellent
        post :do_publish
        post :do_reject
        post :undo_publish
      end
      collection do
        post :batch_do_publish
        post :batch_undo_publish
        post :batch_do_reject
        post :batch_set_excellent
        post :batch_unset_excellent
        delete :batch_destroy
      end
    end
    resources :info_flows do
      member do
        get :columns_and_ads
        post :update_columns
        post :update_ads
        get :edit_columns
        get :edit_ads
        delete :destroy_column
        delete :destroy_ad
      end
    end
    resources :mobile_ads

    get 'tools/redis'
    post 'tools/redis_refresh'
    get 'tools/report'
    post 'tools/gen_post_report'
  end

  namespace :components do
    get '/next/collections', to: 'next#collections', as: :next_collections
    get 'pages/show', to: 'pages#show', as: :page_body
    get 'posts/show', to: 'posts#show', as: :post_body
  end

  namespace :asynces do
    resources :posts, only: [] do
      get :hots, on: :collection
      get :today, on: :collection
      get :record_post_manage_session_path, on: :collection
      resources :comments, :only => [:index, :create]
    end

    resources :comments, only: [] do
      get :excellents, on: :collection
    end

    resources :favorites, only: [:create]

    resources :related_links, only: [] do
      get :get_metas_info, on: :collection
    end

    resources :head_lines, only: [] do
      get :get_metas_info, on: :collection
    end

    resources :dashboard, only: [] do
      get :charts, on: :collection
      get :pandect, on: :collection
    end

    resources :newsflashes, only: [:index]
  end

  resources :pages, only: [:show], param: :slug do
    get :hire, on: :collection
  end

  match '/current_user.json', to: 'users#current', via: :get
  match '/current_user_favorites.json', to: 'users#favorites', via: :get
  match '/upadte_current_user.json', to: 'users#update_current', via: :post
  match '/cancel_favorites', to: 'users#cancel_favorites', via: :get
  match '/comments/excellents', :controller => 'comments', :action => 'execllents', via: :get
  match '/columns/:slug/feed', :controller => 'columns', :action => 'feed', via: :get, as: :column_feed, defaults: { format: :rss }
  match '/columns/:slug(/:page)', :controller => 'columns', :action => 'show', via: :get, as: :column_slug
  match '/category/:slug(/:page)', :controller => 'columns', :action => 'show', via: :get
  match '/p/(:url_code).html' => 'posts#show', via: :get, as: :post_show_by_url_code

  match '/baidu/feed/' => 'posts#baidu_feed', via: :get, defaults: { format: :rss }
  match '/baidu/(:url_code)' => 'posts#bdnews', via: :get, as: :post_bdnews
  match '/xiaozhi/feed/' => 'posts#xiaozhi_feed', via: :get, defaults: { format: :rss }
  match '/xiaozhi/(:url_code)' => 'posts#xiaozhi_news', via: :get, as: :xiaozhi_news
  match '/chouti/feed/' => 'posts#chouti_feed', via: :get, defaults: { format: :rss }
  match '/chouti/(:url_code)' => 'posts#chouti_news', via: :get, as: :chouti_news
  match '/coop/:coop/feed/' => 'posts#coop_feed', via: :get, defaults: { format: :rss }
  match '/coop/:coop/(:url_code).html' => 'posts#coop_news', via: :get
  match '/crop/:partner/feed' => 'posts#partner_feed', via: :get, defaults: { format: :rss }

  match '/newsflash/coop/:coop/feed/' => 'newsflashes#news_corp_feed', via: :get, defaults: { format: :rss }
  match '/newsflash/coop/(:id).html' => 'newsflashes#news_corp_news', via: :get

  match '/uc/feed/' => 'posts#uc_feed', via: :get, defaults: { format: :rss }
  match '/uc/(:url_code)' => 'posts#ucnews', via: :get, as: :uc_news
  match '/p/(:url_code)(.:format)' => 'posts#show', via: :get, constraints: { format: '' }
  match '/p/preview/(:key).html' => 'posts#preview', via: :get, as: :preview_post_by_key
  match '/feed/bdnews_feed_d9rIUTwdPm' => 'posts#feed_bdnews', via: :get, defaults: { format: :rss }
  match '/feed/:params(.:format)' => redirect('/feed'), via: :get
  match '/feed(/:params)' => 'posts#feed', via: :get, defaults: { format: :rss }, as: :feed
  match '/tag/:tag', :controller => 'tags', :action => 'show', via: :get, as: :tag
  match '/clipped/:year/:month/:day', :controller => 'newsflashes', :action => 'index', via: :get, as: :newsflashes_of_day
  match '/clipped/feed/', :controller => 'newsflashes', :action => 'feed', ptype: '_newsflash', via: :get, defaults: { format: :rss }
  match '/clipped/:id', :controller => 'newsflashes', :action => 'show', via: :get, as: :newsflash_show
  match '/clipped/:id/touch_view', :controller => 'newsflashes', :action => 'touch_view', via: :post, as: :newsflash_touch_view
  match '/clipped/touch_views', :controller => 'newsflashes', :action => 'touch_views', via: :post, as: :newsflash_touch_views
  match '/product_notes', :controller => 'newsflashes', :action => 'product_notes', ptype: '_pdnote', via: :get, as: :product_notes
  match '/product_notes/feed/', :controller => 'newsflashes', :action => 'feed', ptype: '_pdnote', via: :get, defaults: { format: :rss }
  match '/newsflashes/', :controller => 'newsflashes', :action => 'newsflashes', ptype: '_newsflash', via: :get, as: :newsflashes_list
  match '/newsflashes/search', :controller => 'newsflashes', :action => 'search', via: :get, as: :newsflashes_search
  match '/changelog', :controller => 'welcome', :action => 'changes', via: :get, as: :changes
  match '/posts/article_toggle_tag', to: 'posts#article_toggle_tag', via: :post, as: :article_toggle_tag
  match '/newsflashes/toggle_tag', to: 'newsflashes#toggle_tag', via: :post, as: :newsflash_toggle_tag
  match '/posts/:user_domain', to: 'users#posts', via: :get, as: :user_domain_posts

  # 兼容老站，添加特定的URL映射
  match '/about' => redirect('/pages/about'), via: :get
  match '/hire' => redirect('/pages/hire'), via: :get
  match '/contribute' => redirect('/pages/contribute'), via: :get
  match '/ads' => redirect('/pages/ads'), via: :get
  match '/ad' => redirect('/pages/ads'), via: :get
  match '/account(/*any)' => redirect('/pages/app'), via: :get
  match '/api/site_map.:format' => "welcome#site_map", via: :get, constraints: { format: 'xml' }
  match '/api/site_map2.:format' => "welcome#site_map2", via: :get, constraints: { format: 'xml' }
  match '/api/wx.:format' => "search#search", via: :get, constraints: { format: 'xml' }
  match '/api/wx/column.:format' => "columns#show", via: :get, constraints: { format: 'xml' }
  match '/:year(/:month)(/:day)' => "posts#archives", via: :get, :constraints => { :year => /201\d{1}/, :month => /\d{1,2}/, :day => /\d{1,2}/ }, as: :post_archives

  %w(404 500).each do |code|
    match code, to: "errors#render_#{code}", via: [:get, :post, :put, :delete]
  end
end
