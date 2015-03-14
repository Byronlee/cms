require 'sidekiq/web'

Rails.application.routes.draw do

  get 'users/messages'

  get 'tags/show'

  mount API::API => '/'
  mount GrapeSwaggerRails::Engine => '/api/a14f30b8405857de59e098af4d1d07bda752a2dc'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }

  root 'welcome#index'

  namespace :admin, path: '/krypton_d29tZW5qaW5ncmFuZmFubGV6aGVtZWRpamlkZWN1b3d1' do
    mount Sidekiq::Web => '/sidekiq'
    root to: redirect('/krypton_d29tZW5qaW5ncmFuZmFubGV6aGVtZWRpamlkZWN1b3d1/dashboard')
    resources :dashboard, :pages, :newsflashes
    resources :users, :ads
    resources :head_lines, except: [:show]
    resources :columns do
      resources :posts, only: [:index], on: :collection do
        get :reviewings, on: :collection
      end
    end
    resources :posts do
      resources :comments, only: [:index], on: :collection
      get :reviewings, on: :collection
      post :publish, on: :member
    end
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
    resources :head_lines, only: [:index]
    resources :info_flows, only: [:index]
    resources :comments, only: [:index]
    resources :posts do
      get :today_lastest, on: :collection
      get :hot_posts, on: :collection
      get :weekly_hot, on: :collection
    end
  end

  resources :posts, :only => [:index] do
    post :update_views_count, on: :member
    get :get_comments_count, on: :member
    resources :comments, :only => [:index, :create] do
      get :normal_list, on: :collection
    end
  end
  resources :columns, only: [:index]
  match '/columns/:slug(/:page)', :controller => 'columns', :action => 'show', via: :get
  match '/category/:slug(/:page)', :controller => 'columns', :action => 'show', via: :get
  match '/p/(:url_code).html' => 'posts#show', via: :get, as: :post_show_by_url_code
  resources :pages, only: [:show], param: :slug
  get :feed, to: 'posts#feed', defaults: { format: :rss }
  match '/info_flow/lastest(/:page)', :controller => 'info_flow', :action => 'lastest', via: :get
  match '/tag/:tag', :controller => 'tags', :action => 'show', via: :get

end
