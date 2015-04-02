require 'sidekiq/web'

Rails.application.routes.draw do

  mount API::API => '/'
  mount GrapeSwaggerRails::Engine => '/api/a14f30b8405857de59e098af4d1d07bda752a2dc'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
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
    resources :dashboard, :pages, :newsflashes
    resources :users do
      member do
        put :speak
        put :shutup
      end
    end
    resources :ads
    resources :head_lines, except: [:show]
    resources :columns do
      resources :posts, only: [:index], on: :collection do
        get :reviewings, on: :collection
      end
    end
    resources :posts do
      resources :comments, only: [:index], on: :collection
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

  resources :posts, :only => [:index] do
    get :get_comments_count, on: :member
    get :news, on: :collection
    get :hots, on: :collection
    resources :comments, :only => [:index, :create]
  end

  resources :columns, only: [:index]
  resources :favorites, only: [:create]

  match '/comments/excellents', :controller => 'comments', :action => 'execllents', via: :get
  match '/columns/:slug(/:page)', :controller => 'columns', :action => 'show', via: :get
  match '/category/:slug(/:page)', :controller => 'columns', :action => 'show', via: :get
  match '/p/(:url_code).html' => 'posts#show', via: :get, as: :post_show_by_url_code
  match '/p/(:url_code)(.:format)' => 'posts#show', via: :get, constraints: { format: '' }
  match '/p/preview/(:key).html' => 'posts#preview', via: :get, as: :preview_post_by_key
  resources :pages, only: [:show], param: :slug
  match '/feed/bdnews_feed_d9rIUTwdPm' => 'posts#feed_bdnews', via: :get, defaults: { format: :rss }
  match '/feed(/:params).:format' => redirect('/feed'), via: :get
  match '/feed(/:params)' => 'posts#feed', via: :get, defaults: { format: :rss }
  match '/tag/:tag', :controller => 'tags', :action => 'show', via: :get

  # 兼容老站，添加特定的URL映射
  match '/about' => redirect('/pages/about'), via: :get
  match '/hire' => redirect('/pages/hire'), via: :get
  match '/contribute' => redirect('/pages/contribute'), via: :get
  match '/ads' => redirect('/pages/ads'), via: :get
  match '/ad' => redirect('/pages/ads'), via: :get
  match '/account(/*any)' => redirect('/pages/app'), via: :get

  %w(404 500).each do |code|
    match code, to: "errors#render_#{code}", via: [:get, :post, :put, :delete]
  end
end
