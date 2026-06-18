# app/controllers/bubble_invites_controller.rb

class BubbleInvitesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bubble_member

  # GET /bubble_invites
  def index
    if @bubble_member
      @invites = @bubble_member.invites.where(status: :pending)
    else
      @invites = []
    end
  end

  # PATCH /bubble_invites/:id/accept
  def accept
    @invite = BubbleInvite.find(params[:id])
    @invite.update(status: :accepted)
    @invite.bubbles.each { |bubble| bubble.members << @invite }

    unless @invite.bubble_member
      bubble_member = BubbleMember.create!(user: current_user)
      @invite.update(bubble_member: bubble_member)
    end

    redirect_to bubble_invites_path, notice: 'Invitation accepted.'
  end

  # PATCH /bubble_invites/:id/reject
  def reject
    @invite = BubbleInvite.find(params[:id])
    @invite.update(status: :rejected)
    redirect_to bubble_invites_path, notice: 'Invitation rejected.'
  end

  private

  def set_bubble_member
    @bubble_member = current_user.bubble_member
  end
end


  