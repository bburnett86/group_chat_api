# frozen_string_literal: true

module Api
  module V1
    # The UsersController is responsible for handling user-related requests in the API.
    # It provides actions to list all users, show a specific user, update a user,
    # deactivate a user, and get the follower count of a user.
    class UsersController < ApplicationController
      def index
        render json: User.all
      end

      def show
        user = User.find(params[:id])
        if user
          render json: {
            user: user, followers: user.followers.count, following: user.followed_users.count, message: 'User found'
          }
        else
          render json: { error: 'User not found' }, status: :bad_request
        end
      end

      def update
        user = User.find(params[:id])
        if user
          user.update(update_user_params)
          render json: { user: user, message: 'User updated' }
        else
          render json: { error: 'User not found' }, status: :bad_request
        end
      end

      def destroy
        user = User.find(params[:id])
        user.update(active: false)
        render json: user
      end

      def followers_count
        user = User.find(params[:id])
        render json: user.followers.count
      end

      def following_count
        user = User.find(params[:id])
        render json: user.followed_users.count
      end

      private

      def update_user_params
        params.require(:user).permit(:user_name, :bio, :avatar_url, :show_email, :active, :role)
      end
    end
  end
end
