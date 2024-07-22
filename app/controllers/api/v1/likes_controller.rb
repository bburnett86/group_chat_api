class Api::V1::LikesController < ApplicationController
  before_action :set_likeable, only: [:index, :create]
  before_action :set_like, only: [:destroy]

  def index
    @likes = @likeable.likes

    render json: @likes
  end

  def create
    @like = @likeable.likes.new(like_params)

    if @like.save
      render json: @like, status: :created
    else
      render json: @like.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @like.destroy
  end

  private

  # Identify the likeable object (post or comment) and set it
  def set_likeable
    likeable_types = { post_id: Post, comment_id: Comment }
    likeable_types.each do |param, klass|
      if params[param]
        @likeable = klass.find(params[param])
        break
      end
    end
  end

  def set_like
    @like = Like.find(params[:id])
  end

  def like_params
    params.require(:like).permit(:liked_id, :liker_id)
  end
end