Rails.application.routes.draw do

  API::API.logger Rails.logger
  mount API::API => '/'
  mount GrapeSwaggerRails::Engine => '/api/doc'

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
  end

  namespace :components do
    get '/next/collections', :to => 'next#collections', :as => :next_collections
  end

end
