# app/controllers/api/v1/future_message_alerts_controller.rb
# Controller for managing alert functionalities for future messages via API endpoints.
# This controller handles the creation, updating, showing, and deletion of alerts associated with future messages.

class Api::V1::FutureMessageAlertsController < ActionController::API
  # Ensures an alert object is set up for specific actions that require an existing alert instance.
  before_action :set_future_message_alert, only: [:show, :edit, :update, :destroy]

  # GET /api/v1/future_message_alerts
  # Lists all alerts related to the current user's associated young people.
  def index
    # Retrieve IDs of all young people related to the current user.
    young_person_ids = current_user.young_people.pluck(:id)

    # Fetch all alerts that belong to these young people.
    @future_message_alerts = FutureMessageAlert.where(young_person_id: young_person_ids)

    # Additionally fetches related future messages using the foreign key 'future_message_id' from alerts.
    future_message_ids = @future_message_alerts.pluck(:future_message_id)
    @future_messages = FutureMessage.where(id: future_message_ids, user_id: young_person_ids)
    
    render json: { future_message_alerts: @future_message_alerts, future_messages: @future_messages }
  end

  # POST /api/v1/future_message_alerts
  # Creates a new alert based on parameters submitted from the form.
  def create
    @future_message_alert = FutureMessageAlert.new(future_message_alert_params)
    if @future_message_alert.save
      render json: @future_message_alert, status: :created
    else
      render json: { errors: @future_message_alert.errors.full_messages }, status: :unprocessable_entity
    end      
  end

  # GET /api/v1/future_message_alerts/:id
  # Shows details of a specific alert.
  def show
    render json: @future_message_alert
  end

  # PATCH/PUT /api/v1/future_message_alerts/:id
  # Updates an existing alert based on form data submitted.
  def update
    if @future_message_alert.update(future_message_alert_params)
      render json: @future_message_alert, status: :ok
    else
      render json: { errors: @future_message_alert.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/future_message_alerts/:id
  # Deactivates a future message alert rather than deleting it from the database.
  def destroy
    @future_message_alert.destroy
    render json: { message: 'Future message alert was successfully deactivated.' }
  end

  private

  # Finds the FutureMessageAlert based on the ID provided in params.
  def set_future_message_alert
    @future_message_alert = FutureMessageAlert.find(params[:id])
  end

  # Permits only the safe parameters for creating or updating alerts.
  def future_message_alert_params
    params.require(:future_message_alert).permit(:future_message_id, :commit)
  end
end
