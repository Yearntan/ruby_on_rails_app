# app/controllers/api/v1/answer_alerts_controller.rb

# This controller handles the API endpoints for managing answer alerts.

class Api::V1::AnswerAlertsController < ActionController::API
  before_action :set_answer_alert, only: [:show, :update, :destroy]

  # GET /api/v1/answer_alerts
  # Returns a list of answer alerts and their associated answers for the current user's young people.
  def index
    young_person_ids = current_user.young_people.pluck(:id)
    @answer_alerts = AnswerAlert.where(young_person_id: young_person_ids)
    answer_ids = @answer_alerts.pluck(:answer_id)
    @answers = Answer.where(id: answer_ids, user_id: young_person_ids)

    render json: { answer_alerts: @answer_alerts, answers: @answers }
  end

  # GET /api/v1/answer_alerts/:id
  # Returns the details of a specific answer alert.
  def show
    render json: @answer_alert
  end

  # POST /api/v1/answer_alerts
  # Creates a new answer alert.
  def create
    @answer_alert = AnswerAlert.new(answer_alert_params)
    if @answer_alert.save
      render json: @answer_alert, status: :created
    else
      render json: @answer_alert.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/answer_alerts/:id
  # Updates an existing answer alert.
  def update
    if @answer_alert.update(answer_alert_params)
      render json: @answer_alert
    else
      render json: @answer_alert.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/answer_alerts/:id
  # Deactivates an answer alert.
  def destroy
    if @answer_alert.update(active: false)
      head :no_content
    else
      render json: { error: 'Failed to deactivate answer alert.' }, status: :unprocessable_entity
    end
  end

  private

  # Sets the @answer_alert instance variable based on the provided ID parameter.
  def set_answer_alert
    @answer_alert = AnswerAlert.find(params[:id])
  end

  # Defines the permitted parameters for creating/updating an answer alert.
  def answer_alert_params
    params.require(:answer_alert).permit(:answer_id, :commit)
  end
end
