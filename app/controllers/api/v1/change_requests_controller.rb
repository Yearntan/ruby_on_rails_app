# app/controllers/api/v1/change_requests_controller.rb
# Controller for managing change requests via API endpoints.
# This controller handles actions related to change requests such as listing, showing, creating, and deleting.
# Only authorized supporters and admins can perform these actions.

class Api::V1::ChangeRequestsController < ActionController::API
  before_action :authenticate_user!
  before_action :ensure_supporter_admin, only: [:index, :show, :destroy]

  # GET /api/v1/change_requests
  # Retrieves all change requests.
  def index
    @change_requests = ChangeRequest.all
    @questions = Question.all
    render json: { change_requests: @change_requests, questions: @questions }
  end

  # GET /api/v1/change_requests/:id
  # Retrieves details of a specific change request.
  def show
    @change_request = ChangeRequest.find(params[:id])
    render json: @change_request
  end

  # POST /api/v1/questions/:question_id/change_requests
  # Creates a new change request for a specific question.
  def create
    @question = Question.find(params[:question_id])
    @change_request = @question.change_requests.build(change_request_params)
    if @change_request.save
      render json: @change_request, status: :created
    else
      render json: { errors: @change_request.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/change_requests/:id
  # Deletes a specific change request.
  def destroy
    @change_request = ChangeRequest.find(params[:id])
    @change_request.destroy
    render json: { message: 'Change request was successfully deleted.' }
  end

  private

  # Whitelists permissible parameters for creating change requests.
  def change_request_params
    params.require(:change_request).permit(:status, :content)
  end

  # Ensures that only supporters and admins can access certain actions.
# Checks if user is a supporter admin, otherwise redirects to root path
  def ensure_supporter_admin
    unless current_user.admin? || current_user.supporter?
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end
end
