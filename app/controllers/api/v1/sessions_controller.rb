# app/controllers/api/v1/sessions_controller.rb
# Manages user sessions including logging in and logging out.
# This controller handles the authentication process and session management for API requests.

class Api::V1::SessionsController < ActionController::API
  # POST /api/v1/login
  # Authenticates a user with the provided email and password.
  def create
    # Find the user by downcased email to avoid case sensitivity issues.
    user = User.find_by(email: params[:session][:email].downcase)

    # If the user exists and the password is correct, proceed to log in.
    if user && user.valid_password?(params[:session][:password])
      log_in user  # Call the log_in helper method to set up the session.
      render json: { success: true, message: 'You have been logged in', user_id: session[:user_id] }
    else
      # If authentication fails, return an error message.
      render json: { success: false, error: 'Invalid email/password combination' }, status: :unauthorized
    end
  end

  # DELETE /api/v1/logout
  # Logs out the current user by clearing the session.
  def destroy
    reset_session  # Resets the session which removes all set data.
    render json: { success: true, message: 'You have been logged out' }
  end

  private

  # Helper method to log in a user.
  def log_in(user)
    session[:user_id] = user.id  # Stores the user's ID in the session to mark as logged in.
  end
end
