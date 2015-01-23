require 'sidekiq/web'

Rails.application.routes.draw do

  API::API.logger Rails.logger
  mount API::API => '/'
  mount GrapeSwaggerRails::Engine => '/api/a14f30b8405857de59e098af4d1d07bda752a2dc'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: {
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations: "users/registrations"
  }

  root 'welcome#index'

  namespace :admin do
    root to: "dashboard#index"
    resources :posts
    resources :columns
    resources :users, :only => [:index]
    resources :head_lines, :except => [:show]
  end

  namespace :components do
    get '/next/collections', :to => 'next#collections', :as => :next_collections
    get '/head_lines', :to => 'head_lines#collections', :as => :spotlight_collections
  end

end
