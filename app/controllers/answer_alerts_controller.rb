# app/controllers/answer_alerts_controller.rb
# Manages the creation, modification, and viewing of alert notifications for answers.
# This controller handles operations for setting up alerts on certain answers, typically from young people managed by the current user.

class AnswerAlertsController < ApplicationController
  # Ensures an AnswerAlert is set for actions that need a specific instance.
  before_action :set_answer_alert, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :make_sure_user_is_supporter, only: [:index, :show, :destroy, :deactivate]
  before_action :make_sure_user_is_admin, only: [:new, :create, :edit, :update]

  # GET /answer_alerts
  # Lists all answer alerts for answers related to the current user's young people.
  def index
    # Retrieve all young_people IDs associated with the current user.
    young_people_ids = YoungPersonManagement.where(supporter_id: current_user.id).pluck(:young_person_id)

    answer_ids = Answer.where(user_id: young_people_ids).pluck(:id)

    # Fetch alerts that correspond to these young people.
    @answer_alerts = AnswerAlert.includes(:answer).where(answer_id: answer_ids)

  end

  # GET /answer_alerts/new
  # Prepares to create a new alert for a specific answer.
  def new
    @answer = Answer.find(params[:answer_id])
    @answer_alert = AnswerAlert.new(answer_id: @answer.id)
  end

  # POST /answer_alerts
  # Creates a new AnswerAlert from submitted parameters.
  def create
    Rails.logger.debug "Submitted parameters: #{params.inspect}"
    @answer_alert = AnswerAlert.new(answer_alert_params)
    if @answer_alert.save
      redirect_to answers_path, notice: 'Answer alert was successfully created.'
    else
      Rails.logger.debug "Errors: #{@answer_alert.errors.full_messages}"
      render :new
    end
  end

  # GET /answer_alerts/:id
  # Shows details of a specific answer alert.
  def show
    # @answer_alert is set by the set_answer_alert method.
  end

  # GET /answer_alerts/:id/edit
  # Prepares an existing alert for editing.
  def edit
    # Ensure that @answer_alert is correctly associated with an answer.
    @answer = @answer_alert.answer
  end

  # PATCH/PUT /answer_alerts/:id
  # Updates a specific answer alert.
  def update
    Rails.logger.debug "Received answer_id: #{params.dig(:answer_alert, :answer_id)}"
    if @answer_alert.update(answer_alert_params)
      redirect_to @answer_alert, notice: 'Answer alert was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /answer_alerts/:id
  # Deactivates an answer alert instead of deleting it from the database.
  def destroy
    if @answer_alert.update(active: false)
      redirect_to answer_alerts_url, notice: 'Answer alert was successfully deactivated.'
    else
      render :index, notice: 'Failed to deactivate answer alert.'
    end
  end

  def deactivate 
    @answer_alert = AnswerAlert.find(params[:id])
    if @answer_alert.update(active: false)
      redirect_to answer_alerts_url, notice: 'Answer alert was successfully deactivated.'
    else
      render :index, notice: 'Failed to deactivate answer alert.'
    end
  end

  private

  # Sets the @answer_alert variable from the database using the ID parameter.
  def set_answer_alert
    @answer_alert = AnswerAlert.find(params[:id])
  end

  # Strong parameters method to prevent mass assignment vulnerabilities.
  # Only permits the answer_id and commit message for an answer alert.
  def answer_alert_params
    params.require(:answer_alert).permit(:answer_id, :commit)
  end

    # Ensures that the current user is a supporter.
    def make_sure_user_is_supporter
      unless current_user.supporter?
        redirect_to root_path, alert: 'You are not authorized to view this page.'
      end
    end
  
    # Ensures that the current user is an admin.
    def make_sure_user_is_admin
      unless current_user.admin?
        redirect_to root_path, alert: 'You are not authorized to view this page.'
      end
    end

end

