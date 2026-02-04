class ApplicationController < ActionController::API
  include Devise::Controllers::Helpers
  include Pundit::Authorization

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone])

  end

  def authenticate_user!
    if request.headers['Authorization'].present?
      begin
        jwt_payload = JWT.decode(
          request.headers['Authorization'].split(' ').last,
          Rails.application.credentials.secret_key_base
        ).first

        @current_user_id = jwt_payload['sub']
      rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def current_user
    @current_user ||= User.find(@current_user_id) if @current_user_id
  end

  def authorize_admin
    render json: { error: 'Librarian access required'}, status: :forbiden unless current_user&.librarian?
  end
end
