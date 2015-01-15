Rails.application.routes.draw do

  API::API.logger Rails.logger
  mount API::API => '/'

  devise_for :users
  root 'welcome#index'

  namespace :admin do 
    root to: "dashboard#index"

    resources :posts
  end
end
