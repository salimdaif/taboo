class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :redirect_to_custom_path, if: -> { current_user }
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Pundit: white-list approach.
  # after_action :verify_authorized, except: :home, unless: :skip_pundit?
  # after_action :verify_policy_scoped, only: :home, unless: :skip_pundit?

  # Uncomment when you *really understand* Pundit!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(root_path)
  end

  private

  def after_sign_in_path_for(resource)
    matches_path

  end

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :age])
  end

  def redirect_to_custom_path
    if !current_user.seen_intro?
      redirect_to intro_path
    elsif !current_user.answered_minimum_questions? && !devise_controller?
      redirect_to user_path(current_user)
    end
  end
end
