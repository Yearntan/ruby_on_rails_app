# app/controllers/api/v1/supporter_managements_controller.rb
# Manages relationships between supporter users and young people via API endpoints.
# This includes listing, viewing, creating, updating, and deleting management records that connect supporters to young people.

class Api::V1::SupporterManagementsController < ActionController::API
  # Ensures the user is authenticated for every action within this controller.
  before_action :authenticate_user!

  # GET /api/v1/supporter_managements
  # Lists all young people associated with the currently logged-in supporter.
  def index
    # Ensures only supporters can access this page.
    if current_user.supporter?
      @young_people = current_user.young_people
      render json: @young_people
    else
      render json: { error: 'Access Denied' }, status: :unauthorized
    end
  end

  # GET /api/v1/supporter_managements/:id
  # Shows details of a specific supporter management entry, typically details about a young person managed by a supporter.
  def show
    @supporter_management = current_user.supporter_managements.find(params[:id])
    render json: @supporter_management
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Record not found' }, status: :not_found
  end

  # POST /api/v1/supporter_managements
  # Creates a new supporter management record linking a supporter to a young person.
  def create
    @supporter_management = current_user.supporter_managements.build(supporter_management_params)

    if @supporter_management.save
      render json: @supporter_management, status: :created
    else
      render json: { error: @supporter_management.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/supporter_managements/:id
  # Updates an existing supporter management record.
  def update
    @supporter_management = current_user.supporter_managements.find(params[:id])

    if @supporter_management.update(supporter_management_params)
      render json: @supporter_management
    else
      render json: { error: @supporter_management.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/supporter_managements/:id
  # Destroys a supporter management record, effectively ending the management relationship.
  def destroy
    @supporter_management = current_user.supporter_managements.find(params[:id])
    @supporter_management.destroy
    head :no_content
  end

  private
    # Permits only the necessary parameters to pass through to prevent mass assignment vulnerabilities.
    def supporter_management_params
      params.require(:supporter_management).permit(:young_person_id, :status)
    end
end
