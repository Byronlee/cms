Rails.application.routes.draw do

  devise_for :users
  root 'welcome#index'

  namespace :admin do 
    root to: "dashboard#index"

    resources :posts
  end
end
