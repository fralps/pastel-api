# frozen_string_literal: true

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if ENV['ENVIRONMENT'] == 'development' || ENV['ENVIRONMENT'] == 'staging'

  devise_for :users, skip: :all

  devise_scope :user do
    scope '/api/v1/users', defaults: { format: :json } do
      post   '/sign_in',       to: 'api/v1/users/sessions#create'
      delete '/sign_out',      to: 'api/v1/users/sessions#destroy'
      post   '/sign_up',       to: 'api/v1/users/registrations#create'
      put    '/profile',       to: 'api/v1/users/registrations#update'
      delete '',               to: 'api/v1/users/registrations#destroy'
      put    '/password',      to: 'api/v1/users/passwords#update'
      post   '/password',      to: 'api/v1/users/passwords#create'
      get    '/confirmation',  to: 'api/v1/users/confirmations#show'
    end
  end

  get 'healthz' => 'rails/health#show', as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :pings, only: :index
      resources :sleeps, only: [:index, :show, :create, :update, :destroy]
      resources :contacts, only: :create

      namespace :admin do
        resources :users, only: [:index, :destroy]
      end

      # Stats related endpoints
      namespace :stats do
        resources :dashboard_stats, only: :index
      end
    end
  end

  root to: 'home#show'
end
