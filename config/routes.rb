# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # Defines route for WebSocket
  mount ActionCable.server => '/cable'

  devise_for :users, path: '', path_names:
    {
      sign_in: 'login',
      sign_out: 'logout',
      registration: 'signup'
    },
                     controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations'
                     }

  # Defines routes for the API
  namespace :api do
    namespace :v1 do
      resources :users, only: %i[index show update] do
        collection do
          patch :admin_update_role_bulk
        end
        patch 'admin_user_update', on: :member
        patch 'activate', on: :member
        patch 'deactivate', on: :member
        get 'following', to: 'users#following'
        get 'followers', to: 'users#followers'
        get 'following_count', to: 'users#following_count'
        get 'followers_count', to: 'users#followers_count'
        resources :blocks, only: %i[index create destroy]
        resources :posts, only: %i[index]
        resources :events
        resources :clubs
      end
      resources :follows, only: %i[create destroy]
      resources :posts do
        resources :likes, only: %i[index create destroy]
        resources :comments, only: %i[create edit destroy] do
          resources :likes, only: %i[index create destroy]
        end
      end
      resources :events do
        resources :event_guests, only: %i[index create destroy]
        resources :event_forums
      end
      resources :clubs do
        resources :club_events
        resources :club_members
        resources :club_forums
      end
      resource :posts, only: [:index]
    end
  end
end
