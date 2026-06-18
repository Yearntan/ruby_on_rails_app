# app/controllers/sessions_controller.rb
# Manages user sessions including logging in and logging out.
# This controller handles the authentication process and session management.

class SessionsController < ApplicationController
  # GET /login
  # Renders the login page where users can enter their email and password.
  def new
  end

  # POST /sessions
  # Attempts to authenticate the user with the provided email and password.
  def create
    # Find the user by downcased email to avoid case sensitivity issues.
    user = User.find_by(email: params[:session][:email].downcase)

    # If the user exists and the password is correct, proceed to log in.
    if user && user.valid_password?(params[:session][:password])
      log_in user  # Call the log_in helper method to set up the session.
      flash[:success] = 'You have been logged in, user id is: ' + session[:user_id].to_s
      redirect_to user  # Redirects to the user's show page.
    else
      # If authentication fails, re-render the login form with a flash message.
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  # DELETE /logout
  # Logs out the current user by clearing the session.
  def destroy
    # log_out  # This would be a custom method to handle logout if defined.
    reset_session  # Resets the session which removes all set data.
    flash[:success] = 'You have been logged out'
    redirect_to root_url  # Redirects to the home page after logging out.
  end

  private

  # Helper method to log in a user.
  def log_in(user)
    session[:user_id] = user.id  # Stores the user's ID in the session to mark as logged in.
  end

  # Helper method to log out a user (commented out if not in use).
  def log_out
    session.delete(:user_id)  # Removes the user id from the session.
  end
end
