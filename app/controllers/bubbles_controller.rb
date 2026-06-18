# app/controllers/bubbles_controller.rb
# Controller responsible for managing Bubble resources within the application.
# This includes CRUD operations and additional functions for assigning and unassigning members to bubbles.

class BubblesController < ApplicationController
    # Ensures a user is authenticated for all actions within this controller.
    before_action :authenticate_user!
    
    
    before_action :set_bubble, only: %i[show update destroy manage_members update_members invite_loved_one create_invite]
    before_action :set_bubble_assign, only: %i[assign unassign]


    # GET /api/v1/bubbles
    # Lists all bubbles associated with the currently logged-in young person.
    def index
        case current_user.role
        when "loved_one"
          # Retrieve answers for 'loved_one' role where the associated young person has passed away.
          manage_loved_one_access
        when "supporter"
          # Retrieve answers for a specific young person for 'supporter' role.
          manage_supporter_access
        when "young_person"
          # Admins can view all answers.
          @bubbles = current_user.young_person.bubbles
        else
          # Redirect unauthorized users.
          redirect_to root_path, alert: "You are not authorized to view this page."
        end
    end

    # GET /api/v1/bubbles/:id
    # Displays a single bubble.
    def show
    end



    # GET /api/v1/bubbles/new
    # Initializes a new bubble instance for creation.
    def new
        @bubble = Bubble.new
    end

    # POST /api/v1/bubbles
    # Creates a new bubble with the provided parameters from the form.
    def create
        @bubble = Bubble.new(bubble_params)
        @bubble.holder_id = YoungPerson.find_by(user_id: current_user.id).id

        if @bubble.save
          redirect_to bubbles_path, notice: 'Bubble was successfully created.'
        else
          render :new
        end
      end

    # GET /api/v1/bubbles/:id/edit
    # Prepares an existing bubble for editing.
    def edit
        @bubble = Bubble.find(params[:id])
    end

    def update
        if @bubble.update(bubble_params)
            redirect_to @bubble, notice: "Bubble was successfully updated."
        else
            render :edit
        end
    end

    # DELETE /api/v1/bubbles/:id
    # Deletes a bubble and redirects to the bubble listing with a success message.
    def destroy
        @bubble.destroy
        redirect_to bubbles_path, notice: "Bubble was successfully destroyed."
    end

    # GET /bubbles/:id/manage_members
    def manage_members
      @bubble = Bubble.find(params[:id])

      bubble_invites = current_user.young_person.invites
      @members = bubble_invites
       # young_person_id = YoungPerson.find_by(user_id: current_user.id).id
      # bubble_invites = BubbleInvite.where(young_person_id: young_person_id)
      # member_ids = bubble_invites.pluck(:bubble_member_id).compact
      # @members = BubbleMember.where(id: member_ids)
    end

    # PATCH /bubbles/:id/update_members
    def update_members
      @bubble = Bubble.find(params[:id])
      if params[:bubble].present?
        @bubble.member_ids = params[:bubble][:member_ids] || []
        if @bubble.save
          redirect_to bubbles_path, notice: 'Bubble members were successfully updated.'
        else
          redirect_to bubbles_path
        end
      else
        @bubble.member_ids = []
        if @bubble.save
          redirect_to bubbles_path, notice: 'Bubble members were successfully updated.'
        else
          redirect_to bubbles_path
        end
      end
    end

        # GET /bubbles/:id/invite_loved_one
    def invite_loved_one
      @loved_ones = User.where(role: :loved_one)
    end

    # POST /bubbles/:id/create_invite
    def create_invite
      @invite = BubbleInvite.new(invite_params)
      @invite.young_person = current_user.young_person
      @invite.bubbles << @bubble
      @invite.status = :pending

      # Ensure BubbleMember exists for the loved_one
      loved_one_user = User.find_by(email: invite_params[:email])

      if loved_one_user.nil?
        flash[:alert] = "User with email #{invite_params[:email]} does not exist."
        render :invite_loved_one and return
      end
      
      unless loved_one_user.bubble_member
        bubble_member = BubbleMember.create!(user: loved_one_user)
        @invite.bubble_member = bubble_member
      else
        @invite.bubble_member = loved_one_user.bubble_member
      end

      if @invite.save
        redirect_to @bubble, notice: 'Loved one was successfully invited.'
      else
        render :invite_loved_one
      end
    end

    private
    # Finds the bubble based on the ID provided in params.
    def set_bubble
      @bubble = Bubble.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to bubbles_path, alert: 'Bubble not found'
    end

    def invite_params
      params.require(:bubble_invite).permit(:email, :name, :bubble_member_id)
    end

    # Permits only the safe parameters for creating and updating bubbles.
    def bubble_params
        params.require(:bubble).permit(:name, :content, :holder_id)
    end

    def manage_loved_one_access
        bm = BubbleMember.find_by(user_id: current_user.id)
        bubble_invites = BubbleInvite.where(bubble_member_id: bm&.id)
        @bubbles = bubble_invites.flat_map(&:bubbles)

    end

    def manage_supporter_access
        if params[:user_id]
          young_person = YoungPerson.find_by(user_id: params[:user_id])
          if young_person
            @bubbles = young_person.bubbles
          else
            redirect_to young_person_managements_path, alert: "No young person found."
          end
        else
          redirect_to young_person_managements_path, alert: "No young person selected."
        end
    end


end
