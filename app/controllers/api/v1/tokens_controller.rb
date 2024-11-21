class Api::V1::TokensController < ApplicationController
  before_action :authenticate_user!

  def verify
    user_role = current_user.role
    render json: { role: user_role }, status: :ok
  end
end