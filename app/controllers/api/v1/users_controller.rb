# app/controllers/api/v1/users_controller.rb
# Manages user profiles and their interactions in the system via API endpoints, including viewing,
# editing, and updating user profiles, as well as managing user roles and states.

class Api::V1::UsersController < ActionController::API
  # Ensures a user is set for any actions that require an existing user.
  before_action :set_user_message, only: %i[show edit update destroy]

  # GET /api/v1/users/:id
  # Shows detailed information about a user. It includes management details if the user is a 'young_person'.
  def show
    if @user.role == 'young_person' && @user.young_person
      # Fetch current and previous management details involving this user.

    else
      # Empty arrays if the user does not have associated young_person or is not 'young_person' role.
      @current_supporters = []
      @previous_supporters = []
    end
    render json: { user: @user, current_supporters: @current_supporters, previous_supporters: @previous_supporters }
  end

  # GET /api/v1/users
  # Displays a list of all users. Accessible typically by admins.
  def index
    @users = User.all
    render json: @users
  end

  # POST /api/v1/users
  # Creates a new user.
  def create
    @user = User.new(user_params)
    
   
  end

  # PATCH/PUT /api/v1/users/:id
  # Updates an existing user's details.
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/users/:id
  # Destroys a user account.
  def destroy
    @user.destroy
    head :no_content
  end

  private
    # Finds and sets the user based on the user ID in the request parameters.
    def set_user_message
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found' }, status: :not_found
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
      permitted_params = [:name, :email, :pronouns, :status, :role, :password, :user]

      params.require(:user).permit(permitted_params)
    end
end
