# app/controllers/api/v1/members_controller.rb
# Controller for managing member resources via API endpoints.
# This controller handles the CRUD operations for members associated with the current user's young person record.
class Api::V1::MembersController < ActionController::API
    respond_to :json
    before_action :set_member, only: [:show, :update, :destroy]

    # GET /api/v1/members
    # Retrieves a list of members associated with the current user's young person invites.
    # Members are returned with their associated bubbles if the bubble holder is the current user's young person.
    def index
        unless current_user.present?
            render json: [], status: :unauthorized
            puts "Not logged in"
            return
        end

        members = current_user.young_person.invites



    end

    # GET /api/v1/members/:id
    # Shows details of a specific member, including the bubbles they are part of,
    # filtered by the ownership of the bubbles to ensure they belong to the current user's young person.
    def show

    end

    # POST /api/v1/members
    # Creates a new member under the current user's young person invites.
    # Returns the created member's details if successful; otherwise, returns error messages.
    def create
        @member = current_user.young_person.invites.new(member_params)

    end

    # PUT/PATCH /api/v1/members/:id
    # Updates an existing member's details.
    # Returns the updated member's details if successful; otherwise, returns error messages.
    def update

    end

    # DELETE /api/v1/members/:id
    # Deletes a specified member.
    # Returns a confirmation message if the deletion is successful.
    def destroy

    end

    private

    # Finds and sets a member based on the ID provided in the URL parameters.
    def set_member
        @member = BubbleInvite.find(params[:id])
    end

    # Sanitizes input parameters for creating and updating members.
    def member_params
        params.require(:member).permit(:name, :email)
    end
end
