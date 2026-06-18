# app/controllers/api/v1/bubbles_controller.rb
# Manages Bubble resources through API endpoints, allowing for CRUD operations
# and handling assignments of members to bubbles. The controller requires user authentication
# and returns responses in JSON format.
class Api::V1::BubblesController < ActionController::API
    before_action :authenticate_user! # Ensures user is authenticated for all actions
    respond_to :json
    before_action :set_bubble, only: [:show, :update, :destroy] # Sets the bubble for show, update, and destroy actions
    before_action :set_bubble_assign, only: [:assign, :unassign] # Sets the bubble and member for assign and unassign actions
  
    # Lists all bubbles associated with the current user if they are a young person.
    # Outputs a list of bubbles with their details.
    def index
      unless current_user.present?
        render json: { message: "User is not a young person" }, status: :unauthorized
        return
      end
  
      result = current_user.young_person.bubbles.map do |bubble|
        { id: bubble.id, name: bubble.name, total_members: bubble.members.count }
      end
  
      render json: { bubbles: result }
    end
  
    # Displays detailed information for a specific bubble.
    # Ensures the current user has permission to view the bubble.
    def show
      result = if current_user.young_person.id == @bubble.holder.id
                 bubble_as_json(@bubble)
               else
                 []
               end
  
      render json: result
    end
  
    # Creates a new bubble with parameters provided by the user.
    # Returns the created bubble's information or error messages.
    def create
      @bubble = Bubble.new(bubble_params)
      if @bubble.save
        render json: bubble_as_json(@bubble), status: :created
      else
        render json: @bubble.errors, status: :bad_request
      end
    end
  
    # Updates an existing bubble's details.
    # Returns the updated bubble's information or error messages.
    def update
      if @bubble.update(bubble_params)
        render json: bubble_as_json(@bubble)
      else
        render json: @bubble.errors, status: :bad_request
      end
    end
  
    # Deletes a specified bubble.
    # Returns a confirmation of deletion.
    def destroy
      result = { bubble: @bubble.destroy, status: "deleted" }
      render json: result, status: :accepted
    end
  
    # Adds a member to a specified bubble.
    # Returns the updated bubble's information.
    def assign
      @bubble.members << @member
      render json: bubble_as_json(@bubble), status: :accepted
    end
  
    # Removes a member from a specified bubble.
    # Returns the updated bubble's information.
    def unassign
      @bubble.members.delete @member
      render json: bubble_as_json(@bubble), status: :accepted
    end
  
    private
  
    # Converts a bubble into a JSON-friendly format with detailed member information.
    def bubble_as_json(bubble)
      {
        id: bubble.id,
        name: bubble.name,
        holder_id: bubble.holder_id,
        members: bubble.members.map { |member| { id: member.id, name: member.name, email: member.email } }
      }
    end
  
    # Finds the bubble based on the ID provided in the parameters.
    def set_bubble
      @bubble = Bubble.find(params[:id])
    end
  
    # Finds the bubble and member based on parameters provided for assign and unassign actions.
    def set_bubble_assign
      @bubble = Bubble.find(params[:bubble_id])
      @member = BubbleInvite.find(params[:member][:id])
    end
  
    # Sanitizes parameters for creating and updating bubbles.
    def bubble_params
      params.require(:bubble).permit(:name, :holder_id)
    end
  end