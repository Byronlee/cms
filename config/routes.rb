Rails.application.routes.draw do

  API::API.logger Rails.logger
  mount API::API => '/'

  devise_for :users, controllers: {
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations: "users/registrations"
  }

  root 'welcome#index'

end
