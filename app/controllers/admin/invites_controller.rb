# Defines a controller within the Admin namespace to handle Invite management.
module Admin
  class InvitesController < ApplicationController
    # Ensures that a user is authenticated before accessing any action in this controller.
    before_action :authenticate_user!
    # Ensures that the user is an admin before allowing access to any action.
    before_action :ensure_admin

    # GET /admin/invites
    # Displays a list of all invites, ordered by creation time in descending order.
    def index
      @invites = Invite.order(created_at: :desc)
    end

    # DELETE /admin/invites/:id
    # Attempts to find and destroy an invite by its id and redirects if destroy is successful
    def destroy
      @invite = Invite.find(params[:id]) 
      if @invite.destroy 
        redirect_to admin_invites_path, notice: 'Invite was successfully destroyed.'
      else
        redirect_to admin_invites_path, alert: 'Failed to destroy the invite.'
      end
    end

    private

    # A private method to check if the current user is an admin.
    # Redirects to the home page with an alert if the user is not an admin.
    def ensure_admin
      redirect_to(root_path, alert: 'Not authorized') unless current_user.admin?
    end
  end
end
