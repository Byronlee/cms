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
    resources :info_flows, only:[:index] do
      get :edit, on: :collection
      post :update, on: :collection
      delete :destroy, on: :member
    end
  end

  namespace :components do
    get '/next/collections', to: 'next#collections', as: :next_collections
    resources :head_lines, only: [:index]
  end

  resources :posts, :only => [:show, :index] do
    resources :comments, :only => [:index, :create] do
      get :normal_list, on: :collection
    end
  end
  get :feed, to: 'posts#feed', defaults: { format: :rss }
end
