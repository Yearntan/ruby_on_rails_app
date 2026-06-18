# app/controllers/api/v1/invites_controller.rb
# Controller for managing user invitations via API endpoints.
# This controller handles the creation and sending of invitations to new users, with role-based access control.

class Api::V1::InvitesController < ActionController::API
  before_action :authenticate_user!
  before_action :check_permissions, only: [:create]

  # POST /api/v1/invites
  # Creates and sends an invitation to a new user
  def create
    @invite = current_user.invites.new(invite_params)
    if @invite.save
      ApplicationMailer.send_invite_email(current_user, @invite.email, @invite.token, params[:invite][:message]).deliver_now
      render json: { message: 'Invite sent successfully.' }, status: :created
    else
      render json: { errors: @invite.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Permits only the allowed parameters for creating an invitation
  def invite_params
    params.require(:invite).permit(:email, :role, :message)
  end

  # Checks permissions based on the current user's role before creating an invitation
  def check_permissions
    if params[:invite] && params[:invite][:role]
      case current_user.role
      when 'admin'
        unless ['admin', 'supporter'].include?(params[:invite][:role])
          render json: { error: "You are not authorized to invite this type of user." }, status: :unauthorized and return
        end
      when 'supporter'
        unless params[:invite][:role] == 'young_person'
          render json: { error: "You are not authorized to invite this type of user." }, status: :unauthorized and return
        end
      when 'young_person'
        unless params[:invite][:role] == 'loved_one'
          render json: { error: "You are not authorized to invite this type of user." }, status: :unauthorized and return
        end
      when 'loved_one'
        render json: { error: "You are not authorized to invite anyone." }, status: :unauthorized and return
      end
    end
  end
end
