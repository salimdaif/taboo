class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :redirect_to_questions, if: -> { current_user && !current_user.answered_minimum_questions? }
  before_action :configure_permitted_parameters, if: :devise_controller?

  private
  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :age])
  end

  def redirect_to_questions
    redirect_to user_path(current_user)
  end
end
