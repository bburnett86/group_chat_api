class Api::V1::LikesController < ApplicationController
  before_action :set_likeable
  before_action :set_like, only: [:destroy]

  # GET /api/v1/posts/:post_id/likes
  def index
    @likes = @likeable.likes

    render json: @likes
  end

  # POST /api/v1/posts/:post_id/likes
  def create
    @like = @likeable.likes.new(like_params)

    if @like.save
      render json: @like, status: :created
    else
      render json: @like.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/posts/:post_id/likes/:id
  def destroy
    @like.destroy
  end

  private

  def set_likeable
    @likeable = Post.find(params[:post_id]) # Adjust this if you have other likeable types
  end

  def set_like
    @like = Like.find(params[:id])
  end

  def like_params
    params.require(:like).permit(:liked_id, :liker_id)
  end
end