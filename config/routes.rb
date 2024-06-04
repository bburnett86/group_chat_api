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
      resources :user do
        get 'following_count', to: 'accounts#following_count'
        get 'followers_count', to: 'accounts#followers_count'
        resources :following, only: %i[index create edit destroy]
        resources :followers, only: %i[index destroy]
        resources :posts
        resources :events
        resources :clubs
      end
      resources :posts do
        resources :post_likes, only: %i[index create destroy]
        resources :comments, only: %i[create edit destroy] do
          resources :comment_likes, only: %i[index create destroy]
        end
        resource :post_likes, only: %i[index create destroy]
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
