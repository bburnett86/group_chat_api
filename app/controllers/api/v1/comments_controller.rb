class Api::V1::CommentsController < ApplicationController
  before_action :set_comment, only: [:update, :destroy]
	before_action :authorize_user!, only: [:update, :destroy]

	def create
		@post = Post.find(params[:post_id])
		@comment = @post.comments.build(comment_params.merge(user_id: current_user.id))
	
		if @comment.save
			render json: @comment, status: :created
		else
			render json: @comment.errors, status: :unprocessable_entity
		end
	end

  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    head :no_content
  end

  private

	def set_comment
		@post = Post.find(params[:post_id])
		@comment = @post.comments.find(params[:id])
	end

	def comment_params
		params.require(:comment).permit(:description)
	end

	def authorize_user!
		unless @comment.user == current_user || current_user.admin? || current_user.superadmin?
			render json: { error: 'You are not authorized to update this comment' }, status: :unauthorized
		end
	end
end