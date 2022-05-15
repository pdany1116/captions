# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :captions
  resources :images, only: [:show]
  resources :users do
    collection do
      post 'sign_up'
      post 'login'
    end
  end
end
