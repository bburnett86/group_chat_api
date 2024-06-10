# frozen_string_literal: true

# The UsersController is responsible for handling user-related requests in the API.
# It provides actions to list all users, show a specific user, update a user,
# deactivate a user, and get the follower count of a user.
class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin, only: [:index, :activate, :deactivate, :admin_user_update]
  before_action :set_user, only: [:show, :update, :activate, :deactivate, :admin_user_update]

  def index
    render json: User.all
  end

  def show
    render json: @user
  end

  def update
    @user.update!(update_user_params)
    render json: @user
  end

  def activate
    if @user.active
      render json: { error: 'User is already active' }, status: :bad_request
    else
      @user.update!(active: true)
      render json: @user
    end
  end

  def deactivate
    if !@user.active
      render json: { error: 'User is already inactive' }, status: :bad_request
    else
      @user.update!(active: false)
      render json: @user
    end
  end

  def admin_user_update
    @user.update!(admin_user_update_params)
    render json: @user
  end

  def admin_update_role_bulk
    params[:user_role_pairs].each do |user_role_pair|
      User.find(user_role_pair[:user_id]).update!(role: user_role_pair[:role])
    end
    render json: { message: 'Roles updated successfully' }
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def update_user_params
    params.require(:user).permit(:username, :show_email, :bio, :avatar_url)
  end

  def admin_user_update_params
    params.require(:user).permit(:username, :role, :active, :show_email, :bio, :avatar_url)
  end
end