# frozen_string_literal: true

Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  namespace :api do
    namespace :v1 do
      resources :tasks
    end
  end
  namespace :admin do
    resources :users
  end
  root to: 'tasks#index'
  resources :tasks do
    get :confirm_destroy
    post :import, on: :collection
  end
end
