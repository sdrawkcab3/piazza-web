Rails.application.routes.draw do
  root "feed#show"

  get "sign_up",    to: "users#new"
  post "sign_up",   to: "users#create"

  get "login",      to: "sessions#new"
  post "login",     to: "sessions#create"
  delete "logout",  to: "sessions#destroy"

  resource :profile, only: [:show, :update], controller: "users"
end
