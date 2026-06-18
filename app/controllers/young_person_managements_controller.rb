# app/controllers/young_person_managements_controller.rb
# Manages relationships between supporters and young people.
# This includes listing, viewing, creating, updating, and deactivating management records.

class YoungPersonManagementsController < ApplicationController
  # Ensures that the user is authenticated for any actions.
  before_action :authenticate_user!
  # Sets the young person for actions that require an existing young person instance.
  before_action :set_young_person, only: [:show, :destroy]

  # GET /young_person_managements
  # Lists all young people under the management of the current supporter user.
  def index
    if current_user.role == 'supporter'
      # Retrieves all young person IDs managed by the current user.
      young_people_ids = YoungPersonManagement.where(supporter_id: current_user.id).pluck(:young_person_id)
      @young_people = YoungPerson.where(user_id: young_people_ids)
    else
      redirect_to root_path, alert: 'Access Denied'
    end
  end 

  # GET /young_person_managements/:id
  # Shows detailed information about a managed young person, including their answers.
  def show
    @user = User.find(params[:id])
    if @user.role == 'young_person'
      @young_person = @user.young_person
      @answers = @young_person.answers.includes(:question)
    else
      redirect_to root_path, alert: 'This user does not have answers or is not accessible.'
    end
  end

  # GET /young_person_managements/new
  # Prepares to create a new management record by listing active supporters.
  def new
    @supporters = Supporter.where(active: true)
    if params[:user_id]
      @young_person = YoungPerson.find_by(user_id: params[:user_id])
      if @young_person.nil?
        flash[:alert] = "No young person found with the given user ID."
        @young_person_management = YoungPersonManagement.new
        render :new
        return
      end
      @young_person_management = YoungPersonManagement.new(young_person_id: @young_person.id)
    else
      flash[:alert] = "No user ID provided."
      @young_person_management = YoungPersonManagement.new
      render :new
      return
    end
  end

  # POST /young_person_managements
  # Creates a new management record linking a supporter with a young person.
  def create
    @young_person_management = YoungPersonManagement.new(young_person_management_params)
    @young_person_management.active = :active
    @young_person = YoungPerson.find_by(user_id: @young_person_management.young_person_id)

    if @young_person.nil?
      flash.now[:alert] = 'Young person not found.'
      render :new
      return
    end

    # Deactivate any currently active management records before saving the new one.
    YoungPersonManagement.where(young_person_id: @young_person.user_id, active: true).each do |management|
      management.update(active: :inactive)
    end

    if @young_person_management.save
      redirect_to users_path, notice: 'Management record created successfully.'
    else
      flash.now[:alert] = 'Error creating management record.'
      render :new
    end
  end

  # Custom action to mark a young person as having passed away.
  # Updates the 'passed_away' status to true.
  def passed_away
    @young_person = YoungPerson.find_by(user_id: params[:user_id])
    if @young_person
      @young_person.update(passed_away: true)
      redirect_to young_person_managements_path, notice: 'Young person status has changed.'
    else
      redirect_to young_person_managements_path, alert: 'Young person not found.'
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
    @young_person = YoungPerson.find_by(user_id: params[:id])
    unless @young_person && current_user.can_manage?(@young_person)
      redirect_to root_path, alert: 'Invalid user.'
    end
  end
end
