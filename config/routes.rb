require 'sidekiq/web'

# TODO路由测试

Rails.application.routes.draw do
  mount API::API => '/'
  mount GrapeSwaggerRails::Engine => '/api/a14f30b8405857de59e098af4d1d07bda752a2dc'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root 'welcome#index'
  get 'search', to: 'search#search'

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
    resources :ads
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
  end

  namespace :components do
    get '/next/collections', to: 'next#collections', as: :next_collections
    get 'pages/show', to: 'pages#show', as: :page_body
  end

  namespace :asynces do
    resources :posts, :only => [] do
      get :hots, on: :collection
      get :today, on: :collection
      get :record_post_manage_session_path, on: :collection
      resources :comments, :only => [:index, :create]
    end

    resources :comments, :only => [] do
      get :excellents, on: :collection
    end

    resources :favorites, only: [:create]

    resources :related_links, only: [] do
      get :get_metas_info, on: :collection
    end

    resources :dashboard, :only => [] do
      get :charts, on: :collection
      get :pandect, on: :collection
    end
  end

  match '/current_user.json', to: 'users#current', via: :get
  match '/current_user_favorites.json', to: 'users#favorites', via: :get
  match '/cancel_favorites', to: 'users#cancel_favorites', via: :get
  match '/comments/excellents', :controller => 'comments', :action => 'execllents', via: :get
  match '/columns/:slug(/:page)', :controller => 'columns', :action => 'show', via: :get
  match '/category/:slug(/:page)', :controller => 'columns', :action => 'show', via: :get
  match '/p/(:url_code).html' => 'posts#show', via: :get, as: :post_show_by_url_code
  match '/baidu/feed/' => 'posts#baidu_feed', via: :get, defaults: { format: :rss }
  match '/baidu/(:url_code)' => 'posts#bdnews', via: :get, as: :post_bdnews
  match '/p/(:url_code)(.:format)' => 'posts#show', via: :get, constraints: { format: '' }
  match '/p/preview/(:key).html' => 'posts#preview', via: :get, as: :preview_post_by_key
  resources :pages, only: [:show], param: :slug
  match '/feed/bdnews_feed_d9rIUTwdPm' => 'posts#feed_bdnews', via: :get, defaults: { format: :rss }
  match '/feed(/:params).:format' => redirect('/feed'), via: :get
  match '/feed(/:params)' => 'posts#feed', via: :get, defaults: { format: :rss }
  match '/tag/:tag', :controller => 'tags', :action => 'show', via: :get
  match '/clipped/:year/:month/:day', :controller => 'newsflashes', :action => 'index', via: :get, as: :newsflashes_of_day
  match '/clipped/:id', :controller => 'newsflashes', :action => 'show', via: :get, as: :newsflash_show
  match '/changelog', :controller => 'welcome', :action => 'changes', via: :get, as: :changes

  # 兼容老站，添加特定的URL映射
  match '/about' => redirect('/pages/about'), via: :get
  match '/hire' => redirect('/pages/hire'), via: :get
  match '/contribute' => redirect('/pages/contribute'), via: :get
  match '/ads' => redirect('/pages/ads'), via: :get
  match '/ad' => redirect('/pages/ads'), via: :get
  match '/account(/*any)' => redirect('/pages/app'), via: :get
  match '/api/site_map.:format' => "welcome#site_map", via: :get, constraints: { format: 'xml' }
  match '/:year(/:month)(/:day)' => "posts#archives", via: :get, :constraints => { :year => /201\d{1}/, :month => /\d{1,2}/, :day => /\d{1,2}/ }, as: :post_archives

  %w(404 500).each do |code|
    match code, to: "errors#render_#{code}", via: [:get, :post, :put, :delete]
  end
end
