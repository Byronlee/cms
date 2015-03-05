require 'sidekiq/web'

Rails.application.routes.draw do

  namespace :components do
  get 'posts/today_lastest'
  end

  mount API::API => '/'
  mount GrapeSwaggerRails::Engine => '/api/a14f30b8405857de59e098af4d1d07bda752a2dc'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }

  root 'welcome#index'

  namespace :admin, path: "/krypton_d29tZW5qaW5ncmFuZmFubGV6aGVtZWRpamlkZWN1b3d1" do
    root to: redirect("/krypton_d29tZW5qaW5ncmFuZmFubGV6aGVtZWRpamlkZWN1b3d1/dashboard")
    resources :dashboard, :pages, :newsflashes
    resources :users, :ads
    resources :head_lines, except: [:show]
    resources :columns do
      resources :posts, only: [:index], on: :collection
    end
    resources :posts do
      resources :comments, only: [:index], on: :collection
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
  end

  resources :posts, :only => [:show, :index] do
    resources :comments, :only => [:index, :create] do
      get :normal_list, on: :collection
    end
  end
  get :feed, to: 'posts#feed', defaults: { format: :rss }
end
