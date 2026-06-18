# app/controllers/api/v1/future_messages_controller.rb
# Controller for managing future messages via API endpoints.
# This controller handles the creation, display, update, deletion, and publication of future messages, with role-based access control.

class Api::V1::FutureMessagesController < ActionController::API
  # Ensures an authenticated user for all actions
  before_action :authenticate_user!
  # Ensures a future message is set for specific actions
  before_action :set_future_message, only: [:show, :edit, :update, :destroy, :publish]
  # Restricts index, edit, update, and destroy actions to users with appropriate roles
  before_action :ensure_user, only: [:index, :edit, :update, :destroy]
  # Restricts the publish action to admins
  before_action :ensure_admin, only: [:publish]

  # GET /api/v1/future_messages
  # Displays future messages based on the user's role and associated young people or bubbles
  def index
    @future_messages = case current_user.role
                       when "loved_one"
                         manage_loved_one_access
                       when "supporter"
                         manage_supporter_access
                       when "admin"
                         FutureMessage.all
                       when "young_person"
                         current_user.young_person.future_messages
                       else
                         render json: { error: "You are not authorized to view this page." }, status: :unauthorized and return
                       end
    render json: @future_messages
  end

  # GET /api/v1/future_messages/1
  # Displays a single future message, details are fetched by before_action
  def show
    render json: @future_message
  end

  # POST /api/v1/future_messages
  # Creates a new future message
  def create
    @future_message = current_user.young_person.future_messages.new(future_message_params.except(:bubble_ids))

    if @future_message.save
      render json: @future_message, status: :created
    else
      render json: { errors: @future_message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/future_messages/1
  # Updates an existing future message
  def update
    if @future_message.update(future_message_params)
      render json: @future_message, status: :ok
    else
      render json: { errors: @future_message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/future_messages/1
  # Destroys a future message
  def destroy
    @future_message.destroy
    render json: { message: 'Future message was successfully destroyed.' }
  end

  # POST /api/v1/future_messages/1/publish
  # Marks a future message as publishable by an admin
  def publish
    if @future_message.update(publishable: true)
      render json: { message: 'Future message was successfully published.' }
    else
      render json: { error: 'Unable to publish the future message.' }, status: :unprocessable_entity
    end
  end

  private
    # Finds the FutureMessage based on the ID provided in params
    def set_future_message
      @future_message = FutureMessage.find(params[:id])
    end

    # Permits only the allowed parameters through for creating or updating future messages
    def future_message_params
      params.require(:future_message).permit(:content, :published_at, bubble_ids: [])
    end

    # Checks if the user is authorized to perform certain actions based on their role
    def ensure_user
      unless current_user.young_person? || current_user.admin? || current_user.supporter? || current_user.loved_one?
        render json: { error: "You are not authorized to access this page." }, status: :unauthorized and return
      end

      restrict_admin_actions if current_user.admin?
    end

    # Ensures only admins can perform certain actions
    def ensure_admin
      unless current_user.admin?
        render json: { error: "You are not authorized to access this page." }, status: :unauthorized and return
      end
    end

    # Redirects admin if trying to perform actions restricted to non-admin roles
    def restrict_admin_actions
      case action_name
      when 'edit', 'update', 'create', 'destroy', 'new'
        render json: { error: "You are not authorized to perform this action." }, status: :unauthorized and return
      end
    end

    # Only displays messages that is associated with the patient 
    def manage_loved_one_access
      bm = BubbleMember.find_by(user_id: current_user.id)
      bubble_invites = BubbleInvite.where(bubble_member_id: bm&.id)
      bubbles = bubble_invites.flat_map(&:bubbles)
    
      @future_messages = bubbles.flat_map do |bubble|
        future_messages_bubbles = FutureMessagesBubble.where(bubble_id: bubble.id)
        future_messages = FutureMessage.where(id: future_messages_bubbles.pluck(:future_message_id), publishable: true)
        future_messages.flat_map(&:content)
      end.compact
    end
    
    def manage_supporter_access
      if params[:user_id]
        young_person = YoungPerson.find_by(user_id: params[:user_id])
        if young_person
          @future_messages = young_person.future_messages
        else
          render json: { error: "No young person found." }, status: :not_found and return
        end
      else
        render json: { error: "No young person selected." }, status: :unprocessable_entity and return
      end
    end
end
