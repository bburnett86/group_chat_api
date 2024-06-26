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
        member do
          patch 'admin_user_update'
          patch 'activate'
          patch 'deactivate'
          get 'following'
          get 'followers'
          get 'events'
          get 'clubs'
          get 'posts'
        end
        resources :blocks, only: %i[index create destroy]
      end
      resources :follows, only: %i[create destroy]
      resources :posts do
        resources :likes, only: %i[index create destroy]
        resources :comments, only: %i[create update destroy] do
          resources :likes, only: %i[index create destroy]
        end
      end
      resources :events do
        collection do
          patch :deactivate_past_events
          post :bulk_invite_guests
          patch :bulk_role_updates
        end
        member do
          get 'pending_guests'
          get 'going_guests'
          get 'not_going_guests'
          get 'maybe_guests'
          get 'all_guests'
          get 'hosts'
          get 'organizers'
        end
      end 
      resources :clubs do
        collection do
          post :bulk_invite_members
          patch :bulk_role_updates
        end
        member do
          get 'accepted_members'
          get 'pending_members'
          get 'rejected_members'
          get 'admins'
          get 'superadmins'
          get 'members'
        end
        resources :club_events
      end
    end
  end
end