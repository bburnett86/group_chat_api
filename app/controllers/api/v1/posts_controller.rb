class Api::V1::PostsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_post, only: [:show, :update, :destroy]
  before_action :authorize_user!, only: [:update, :destroy]

  def index
    posts = Post.includes(:user, :likes, :comments).all
    render json: posts.as_json(include: {
      user: { only: :username },
      likes: { only: :id }, 
      comments: {
        only: [:id, :description],
        include: {
          likes: { only: :id } 
        }
      },
      postable: { only: [:id, :type] }
    })
  end

  def show
    @post = Post.includes(:user, :likes, :comments).find(params[:id])
    render json: @post.as_json(include: {
      user: { only: :username },
      likes: { only: :id },
      comments: {
        only: [:id, :description],
        include: {
          likes: { only: :id } 
        }
      },
      postable: { only: [:id, :type] }
    })
  end

  def create
    # Extract postable_type and postable_id from params
    postable_type = post_params[:postable_type].constantize
    postable_id = post_params[:postable_id]
  
    # Find the postable entity
    postable = postable_type.find(postable_id)
  
    # Build the post associated with the postable entity
    post = postable.posts.build(post_params.merge(user: current_user))
  
    if post.save
      render json: post, status: :created
    else
      render json: { error: 'Could not create post', details: post.errors.full_messages }, status: :unprocessable_entity
    end
    rescue NameError
      render json: { error: 'Invalid postable_type provided' }, status: :bad_request
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
  end

  def update
    @post.update!(update_post_parms)
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

  def update_post_parms
    params.require(:post).permit(:description, :close_friends)
  end

  def post_params
    params.require(:post).permit(:description, :close_friends, :postable_id, :postable_type)
  end
end