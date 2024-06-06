class Api::V1::FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_follow, only: [:destroy]

  def create
    follow = Follow.create!(follow_params)
    render json: follow
  rescue ActiveRecord::RecordInvalid
    render json: { error: 'Could not follow user' }, status: :bad_request
  end

  def destroy
    @follow.destroy!
    render json: @follow
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Could not unfollow user' }, status: :bad_request
  end

  private

  def set_follow
    @follow = Follow.find_by!(follow_params)
  end

  def follow_params
    params.permit(:following_user_id, :followed_user_id)
  end
end