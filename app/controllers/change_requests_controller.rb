# app/controllers/change_requests_controller.rb
# Controller responsible for managing change requests within the application.
# This includes CRUD operations and additional functions for deleting, creating change request

class ChangeRequestsController < ApplicationController
  # Ensures that user is authenticated before accessing any action
  before_action :authenticate_user!
  # Ensures that only supporter admins can access specified actions
  before_action :ensure_supporter_admin, only: [:index, :show, :edit, :update, :destroy]
  
  # Action to display all change requests
  def index
    @change_requests = ChangeRequest.all
    @questions = Question.all
  end

  # Action to show details of a specific change request
  def show
    @change_request = ChangeRequest.find(params[:id])
  end

  # Action to create a new change request
  def new
    # Finds the question associated with the new change request
    @question = Question.find(params[:question_id])
    # Builds a new change request for the selected question
    @change_request = @question.change_requests.build
  end

  # Action to save a newly created change request
  def create
    # Finds the question associated with the new change request
    @question = Question.find(params[:question_id])
    # Builds a new change request with permitted parameters
    @change_request = @question.change_requests.build(change_request_params)
    # Saves the change request and redirects to questions path if successful
    if @change_request.save
      redirect_to questions_path, notice: 'Change request was successfully created.'
    else
      render :new
    end
  end

  # Action to delete a change request
  def destroy
    # Finds the change request to be deleted
    @change_request = ChangeRequest.find(params[:id])
    # Finds the associated question
    @question = @change_request.question
    # Deletes the change request
    @change_request.destroy
    # Redirects to change requests path after deletion
    redirect_to change_requests_path, notice: 'Change request was successfully deleted.'
  end

  private

  # Defines permitted parameters for change request creation
  def change_request_params
    params.require(:change_request).permit(:status, :question_id, :content)
  end
  
  # Checks if user is a supporter admin, otherwise redirects to root path
  def ensure_supporter_admin
    unless current_user.admin? || current_user.supporter?
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end
end
