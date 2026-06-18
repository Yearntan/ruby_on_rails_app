# app/controllers/supporter_managements_controller.rb
# Manages relationships between supporter users and young people.
# This includes listing, viewing, creating, updating, and deleting management records that connect supporters to young people.

class SupporterManagementsController < ApplicationController
  # Ensures the user is authenticated for every action within this controller.
  before_action :authenticate_user!

  # GET /supporter_managements
  # Lists all young people associated with the currently logged-in supporter.
  def index
    # Ensures only supporters can access this page.
    if current_user.supporter?
      @young_people = current_user.young_people
    else
      redirect_to root_path, alert: 'Access Denied'
    end
  end

  # GET /supporter_managements/:id
  # Shows details of a specific supporter management entry, typically details about a young person managed by a supporter.
  def show
    @young_person = @supporter_management.young_person
  end

  # POST /supporter_managements
  # Creates a new supporter management record linking a supporter to a young person.
  def create
    @supporter_management = current_user.supporter_managements.build(supporter_management_params)

    if @supporter_management.save
      redirect_to @supporter_management, notice: 'Supporter management was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /supporter_managements/:id
  # Updates an existing supporter management record.
  def update
    if @supporter_management.update(supporter_management_params)
      redirect_to @supporter_management, notice: 'Supporter management was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /supporter_managements/:id
  # Destroys a supporter management record, effectively ending the management relationship.
  def destroy
    @supporter_management.destroy
    redirect_to supporter_managements_url, notice: 'Supporter management was successfully destroyed.'
  end

  private
    # Sets the supporter management record for actions that require finding a specific record by ID.
    def set_supporter_management
      @supporter_management = current_user.supporter_managements.find(params[:id])
    end

    # Permits only the necessary parameters to pass through to prevent mass assignment vulnerabilities.
    def supporter_management_params
      params.require(:supporter_management).permit(:young_person_id, :status)
    end
end
