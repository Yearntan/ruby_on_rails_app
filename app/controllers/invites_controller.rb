# app/controllers/invites_controller.rb
# Controller for managing invitations
class InvitesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_permissions, only: [:create]  # Restrict permissions check to the create action only

  # Render form for creating a new invitation
  def new
    @invite = Invite.new
  end

  # Create a new invitation
  def create
    @invite = current_user.invites.new(invite_params)
    if @invite.save
      # Send invitation email using ApplicationMailer
      ApplicationMailer.send_invite_email(current_user, @invite.email, @invite.token, params[:invite][:message]).deliver_now
      redirect_to root_path, notice: 'Invite sent successfully.'
    else
      render :new, notice: 'details are invalid.'
    end
  end

  private

  # Parameters for invitation
  def invite_params
    params.require(:invite).permit(:email, :role, :message)  # Permit email, role, and message parameters
  end

  # Check permissions for creating invitations
  def check_permissions
    # Check for params[:invite] because it's only relevant in the create action
    if params[:invite] && params[:invite][:role]
      case current_user.role
      when 'admin'
        # Allow inviting only admins and supporters
        unless ['admin', 'supporter'].include?(params[:invite][:role])
          redirect_to root_path, alert: "You are not authorized to invite this type of user."
        end
      when 'supporter'
        # Allow inviting only young people
        unless params[:invite][:role] == 'young_person'
          redirect_to root_path, alert: "You are not authorized to invite this type of user."
        end
      when 'young_person'
        # Allow inviting only loved ones
        unless params[:invite][:role] == 'loved_one'
          redirect_to root_path, alert: "You are not authorized to invite this type of user."
        end
      when 'loved_one'
        # Loved ones cannot invite anyone
        redirect_to root_path, alert: "You are not authorized to invite anyone."
      end
    end
  end
end


