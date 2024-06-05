class Api::V1::FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    follow = Follow.new(follow_params)
    if follow.save
      render json: follow
    else
      render json: { error: 'Could not follow user' }, status: :bad_request
    end
  end

  def destroy
    follow = Follow.find_by(follow_params)
    if follow
      follow.destroy
      render json: follow
    else
      render json: { error: 'Could not unfollow user' }, status: :bad_request
    end
  end

  private

  def follow_params
    params.permit(:following_user_id, :followed_user_id)
  end
end
