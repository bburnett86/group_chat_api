class Api::V1::BlocksController < ApplicationController
	before_action :set_user
  before_action :set_block, only: [:destroy]

  # GET /api/v1/users/:user_id/blocks
  def index
    @blocks = @user.blocked_users

    render json: @blocks
  end

  # POST /api/v1/users/:user_id/blocks
  def create
    @block = @user.blocks.new(block_params)

    if @block.save
      render json: @block, status: :created
    else
      render json: @block.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/users/:user_id/blocks/:id
  def destroy
    @block.destroy
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_block
    @block = @user.blocks.find(params[:id])
  end

  def block_params
    params.require(:block).permit(:blocked_user_id)
  end
end