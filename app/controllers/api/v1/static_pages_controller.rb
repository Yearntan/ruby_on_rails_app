# app/controllers/api/v1/static_pages_controller.rb
# Handles API requests for static pages such as 'About', 'Privacy', 'Cookies', and 'New User'.

class Api::V1::StaticPagesController < ActionController::API
  # GET /api/about
  # Returns information about the application.
  def about
    render json: { message: 'This is the About page of the application.' }
  end

  # GET /api/privacy
  # Returns the privacy policy of the application.
  def privacy
    render json: { message: 'This is the Privacy page of the application.' }
  end

  # GET /api/cookies
  # Returns information about the cookies used in the application.
  def cookies
    render json: { message: 'This is the Cookies page of the application.' }
  end

  # GET /api/newuser
  # Returns information about creating a new user account.
  def newuser
    render json: { message: 'This is the New User page of the application.' }
  end
end
