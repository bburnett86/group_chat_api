# frozen_string_literal: true

# The UsersController is responsible for handling user-related requests in the API.
# It provides actions to list all users, show a specific user, update a user,
# deactivate a user, and get the follower count of a user.
class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin, only: %i[index activate deactivate]

  def index
    render json: User.all
  end

  def show
    user = User.find(params[:id])
    render json: {
      user:,
      followers: user.followers.count,
      following: user.followed_users.count
    }
  end

  def update
    user = User.find(params[:id])
    user.update(update_user_params)
    render json: { user:, message: 'User updated' }
  end

  def activate
    user = User.find(params[:id])
    if user && user.active
      user.update(active: true)
      render json: user
    else
      render json: { error: 'User not found or already active' }, status: :bad_request
    end
  end

  def deactivate
    user = User.find(params[:id])
    if user && !user.active
      user.update(active: false)
      render json: user
    else
      render json: { error: 'User not found or already inactive' }, status: :bad_request
    end
  end

  def following
    user = User.find(params[:user_id])
    render json: user.followed_users
  end

  def followers
    user = User.find(params[:user_id])
    render json: user.followers
  end

  def followers_count
    user = User.find(params[:user_id])
    render json: user.followers.count
  end

  def following_count
    user = User.find(params[:user_id])
    render json: user.followed_users.count
  end

  private

  def update_user_params
    params.require(:user).permit(:username, :bio, :avatar_url, :show_email, :active, :role)
  end
end
