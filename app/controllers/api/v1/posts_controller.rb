class Api::V1::PostsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_post, only: [:show, :update, :destroy]
  before_action :authorize_user!, only: [:update, :destroy]

  def index
    posts = Post.all
    render json: posts
  end

  def show
    render json: @post
  end

  def create
    post = current_user.posts.new(post_params)
    if post.save
      render json: post
    else
      render json: { error: 'Could not create post' }, status: :bad_request
    end
  end

  def update
    @post.update!(post_params)
    render json: @post
  end

  def destroy
    post_id = @post.id
    @post.destroy
    render json: { message: 'Post was successfully deleted', post_id: post_id }
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

	def authorize_user!
		unless @post.user == current_user || current_user.admin? || current_user.superadmin?
			render json: { error: 'You are not authorized to update this post' }, status: :unauthorized
		end
	end

  def post_params
    params.require(:post).permit(:description, :close_friends, :post_type)
  end
end