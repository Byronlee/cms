require 'sidekiq/web'

Rails.application.routes.draw do

  mount API::API => '/'
  mount GrapeSwaggerRails::Engine => '/api/a14f30b8405857de59e098af4d1d07bda752a2dc'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }

  root 'welcome#index'

  namespace :admin do
    root to: redirect("/admin/dashboard")
    resources :head_lines, except: [:show]
    resources :pages
    resources :newsflashes
    resources :dashboard
    resources :columns do
      resources :posts, only: [:index], on: :collection
    end
    resources :users
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
    resources :ads
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
  end

  resources :posts, :only => [:show, :index] do
    resources :comments, :only => [:index, :create] do
      get :normal_list, on: :collection
    end
  end
  get :feed, to: 'posts#feed', defaults: { format: :rss }
end
