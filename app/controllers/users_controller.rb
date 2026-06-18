# app/controllers/users_controller.rb
# Manages user profiles and their interactions in the system, including viewing,
# editing, and updating user profiles, as well as managing user roles and states.

class UsersController < ApplicationController
  # Ensures a user is set for any actions that require an existing user.
  before_action :set_user_message, only: %i[show edit update destroy]

  # GET /users/:id
  # Shows detailed information about a user. It includes management details if the user is a 'young_person'.
  def show
    if @user.role == 'young_person' && @user.young_person
      # Fetch current and previous management details involving this user.
      @current_managements = YoungPersonManagement.where(young_person_id: @user.young_person.user_id, active: :active)
      @previous_managements = YoungPersonManagement.where(young_person_id: @user.young_person.user_id, active: :inactive)

      # Collect current and previous supporters based on management records.
      @current_supporters = map_supporters(@current_managements)
      @previous_supporters = map_supporters(@previous_managements)

    else
      # Empty arrays if the user does not have associated young_person or is not 'young_person' role.
      @current_supporters = []
      @previous_supporters = []
    end
  end

  # GET /users
  # Displays a list of all users. Accessible typically by admins.
  def index
    if params[:supporter_id].present?
      young_people = YoungPersonManagement.where(supporter_id: params[:supporter_id], active: :active)
      @users = young_people.map { |yp| User.find(yp.young_person_id) }
    else
      @users = User.all
    end
  end
  

  # GET /users/new
  # Prepares a new user form (unused in provided code but typically here for completeness).
  def new
  end

  # GET /users/:id/edit
  # Loads an existing user for editing.
  def edit
  end

  def create
    @user = User.new(user_params)

  end

  def create
    User.transaction do
      @user = User.new(user_params)
      
      # Retrieve the invite based on the token provided at signup
      invite = Invite.find_by(token: params[:user][:token])
      
      if invite && invite.expiration_date > Time.now && !invite.used
        @user.role = invite.role # Assign the role from the invite
        invite.update!(used: true) # Mark the invite as used
        
        if @user.save
          begin
            case @user.role
            when 'young_person'
              young_person = YoungPerson.create!(user: @user, passed_away: false)
            when 'supporter'
              supporter = Supporter.create!(user: @user)
            end
          end
          
          redirect_to root_url, notice: "User was successfully created with role #{invite.role}."
        else
          Rails.logger.error "Failed to save user: #{@user.errors.full_messages.join(', ')}"
          render :new, alert: 'There was a problem creating the user.'
        end
      else
        @user.errors.add(:token, 'is invalid or has expired')
        Rails.logger.error "Invalid or expired token"
        render :new, alert: "Invalid or expired token."
      end
    end
  end

  # PATCH/PUT /users/:id
  # Updates an existing user's details from form parameters.
  def update
    if @user.update(user_params)
      # Redirect appropriately depending on whether the current user is updating themselves or another user.
      if current_user != @user
        redirect_to @user, notice: "User was successfully updated."
      else
        redirect_to request.referer, notice: "User was successfully updated."
      end
    else
      render :edit
    end
  end

  # DELETE /users/:id
  # Destroys a user account (method body is not provided, so no operation defined here).
  def destroy
  end

  # Custom method to deactivate a supporter user.
  def make_supporter_unactive
    @user = User.find(params[:id])
    @supporter = Supporter.find_by(user_id: @user.id)
    @supporter.update(active: false)
    redirect_to users_path
  end

  # Custom method to activate a supporter user.
  def make_supporter_active
    @user = User.find(params[:id])
    @supporter = Supporter.find_by(user_id: @user.id)
    @supporter.update(active: true)
    redirect_to users_path
  end

  private
    # Finds and sets the user based on the user ID in the request parameters.
    def set_user_message
      @user = User.find(params[:id])
    end

    # Maps supporter details from management records.
    def map_supporters(managements)
      managements.map do |management|
        supporter = Supporter.find_by(user_id: management.supporter_id)
        [supporter, management] if supporter
      end.compact
    end

    # Permits only the safe parameters to be used in create and update actions to prevent mass assignment vulnerabilities.
    def user_params
      permitted_params = [:name, :email, :pronouns , :status, :role]

      # Add password to permitted params only if it's provided or if the user already has a password set.
      if params[:user][:password].present?
        password = params[:user][:password].strip
        params[:user][:password] = password
        permitted_params << :password
      elsif @user.encrypted_password.present?
        permitted_params << :password
      end
    
      params.require(:user).permit(permitted_params)
    end
end
