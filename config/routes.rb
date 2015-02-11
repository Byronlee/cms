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
    root to: redirect('/admin/dashboard')
    resources :dashboard, :columns
    resources :head_lines, except: [:show]
    resources :users, :newsflashes, :pages
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
  end

  namespace :components do
    get '/next/collections', to: 'next#collections', as: :next_collections
    resources :head_lines, only: [:index]
  end

  resources :posts, :only => [:show] do
    resources :comments, :only => [:index, :create] do
      get :normal_list, on: :collection
    end
  end
end
