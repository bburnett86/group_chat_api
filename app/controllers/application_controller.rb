# frozen_string_literal: true

# ApplicationController is the main controller from which all other controllers inherit.
# It includes methods that should be available across all controllers.
class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def authenticate_user!
    render json: { error: 'Not authorized' }, status: :unauthorized unless user_signed_in?
  end

  def check_admin
    if current_user && (current_user.admin? || current_user.superadmin?)
      return
    else
      render json: { error: 'Not authorized' }, status: :unauthorized
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys:
      %i[email password username role avatar_url show_email bio active])
    devise_parameter_sanitizer.permit(:update_password, keys: %i[email password])
  end
end
