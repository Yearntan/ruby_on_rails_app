# app/controllers/api/v1/application_controller.rb
# Base controller from which all other controllers in the application inherit.
# It includes universal functionalities like CSRF protection, user authentication,
# caching policies, and default navigational behaviors after sign-in.

class Api::V1::ApplicationController < ActionController::Base
  # Protects from Cross-Site Request Forgery (CSRF) attacks by raising an exception.
  protect_from_forgery with: :exception

  # Sets HTTP headers to disable caching of responses to prevent sensitive information
  # from being stored in the browser cache.
  before_action :update_headers_to_disable_caching

  # Ensures that a user is authenticated for every action in the application,
  # except where explicitly skipped in child controllers.
  before_action :authenticate_user!

  # Configures the parameter sanitizer for Devise upon user sign-up and account update.
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Provides a helper method to access the current logged-in user across the application views.
  helper_method :current_user
  helper_method :logged_in?

  # Returns the current logged-in user and caches it to avoid multiple database hits.
  def current_user
    @current_user ||= super
  end

  # Returns true if a user session is present, indicating a logged-in state.
  def logged_in?
    !session[:user_id].nil?
  end

  private

  # Modifies HTTP headers to prevent caching, ensuring private or sensitive data isn't stored.
  def update_headers_to_disable_caching
    response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate, private, proxy-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '0'
  end

  # Configures permitted parameter lists for Devise controller actions, particularly for sign-up and account updates.
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :pronouns, :email, :password, :password_confirmation, :token])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :pronouns, :email, :password, :password_confirmation, :current_password])
  end

  # Determines the path to redirect the user after successful sign-in based on their role.
  # This is used by the devise (or similar) authentication framework to handle post-login navigation.
  def after_sign_in_path_for(resource)
    case resource.role
    when 'young_person'
      questions_path  # Path for young_person users, likely to ask questions or see resources
    when 'loved_one'
      answers_path    # Path for loved_one users, probably to see responses or manage settings
    when 'supporter'
      young_person_managements_path  # Path for supporters managing young person accounts
    else
      users_path      # Default path, possibly for admin or other unspecified roles
    end
  end
end