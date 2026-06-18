# app/controllers/api/v1/young_person_managements_controller.rb
# Manages relationships between supporters and young people via API endpoints.
# This includes listing, viewing, creating, updating, and deactivating management records.

class Api::V1::YoungPersonManagementsController < ActionController::API
  # Ensures that the user is authenticated for any actions.
  before_action :authenticate_user!
  # Sets the young person for actions that require an existing young person instance.
  before_action :set_young_person, only: [:show, :destroy]

  # GET /api/v1/young_person_managements
  # Lists all young people under the management of the current supporter user.
  def index
    if current_user.role == 'supporter'
      # Retrieves all young person IDs managed by the current user.
      young_people_ids = YoungPersonManagement.where(supporter_id: current_user.id).pluck(:young_person_id)
      @young_people = YoungPerson.where(user_id: young_people_ids)
      render json: @young_people
    else
      render json: { error: 'Access Denied' }, status: :unauthorized
    end
  end 

  # GET /api/v1/young_person_managements/:id
  # Shows detailed information about a managed young person, including their answers.
  def show
    if @user.role == 'young_person'
      @young_person = @user.young_person
      @answers = @young_person.answers.includes(:question)
      render json: { young_person: @young_person, answers: @answers }
    else
      render json: { error: 'This user does not have answers or is not accessible.' }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/young_person_managements
  # Creates a new management record linking a supporter with a young person.
  def create
    @young_person_management = YoungPersonManagement.new(young_person_management_params)
    @young_person_management.active = :active
    @young_person = YoungPerson.find_by(user_id: @young_person_management.young_person_id)

    if @young_person.nil?
      render json: { error: 'Young person not found.' }, status: :unprocessable_entity
      return
    end

    # Deactivate any currently active management records before saving the new one.
    YoungPersonManagement.where(young_person_id: @young_person.user_id, active: true).each do |management|
      management.update(active: :unactive)
    end

    if @young_person_management.save
      render json: @young_person_management, status: :created
    else
      render json: { error: 'Error creating management record.' }, status: :unprocessable_entity
    end
  end

  # Custom action to mark a young person as having passed away.
  # Updates the 'passed_away' status to true.
  def passed_away
    @young_person = YoungPerson.find_by(user_id: params[:user_id])
    if @young_person
      @young_person.update(passed_away: true)
      render json: { success: true, message: 'Young person has passed away.' }
    else
      render json: { error: 'Young person not found.' }, status: :unprocessable_entity
    end
  end

  private

  # Strong parameters method, allows only specific attributes to be passed to prevent mass assignment vulnerabilities.
  def young_person_management_params
    params.require(:young_person_management).permit(:supporter_id, :young_person_id, :commit)
  end

  # Sets the young person based on the user_id provided in params.
  # Includes an authorization check to ensure that the current user is permitted to manage the young person.
  def set_young_person
    @user = User.find(params[:id])
    unless @user && current_user.can_manage?(@user)
      render json: { error: 'Invalid user.' }, status: :unauthorized
    end
  end
end
