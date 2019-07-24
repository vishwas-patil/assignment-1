class ApplicationController < ActionController::API
  include Response
  include JWTAuthenticate

  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  def current_resource_owner
    user, _payload = fetch_user_payload_from_token
    user
  end

end
