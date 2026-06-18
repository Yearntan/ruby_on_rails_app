# app/controllers/members_controller.rb
# Manages operations related to members, who are associated with the current user's young person profile.
# This includes listing members, creating new members, updating existing members, and deleting members.

class MembersController < ApplicationController
    # GET /members
    # Displays a list of all members associated with the current user's young person profile.
    def index
        # Redirects to the login page if no user is currently logged in.
        return redirect_to login_path unless current_user.present?
  
        # Retrieves all invites (members) associated with the current user's young person.
        @members = current_user.young_person.invites
    end

    # GET /members/:id
    # Displays details of a specific member. This method is intentionally left empty to be defined later or
    # to utilize Rails' convention over configuration where an empty method will still render its view.
    def show
    end

    # POST /members
    # Attempts to create a new member based on form parameters.
    def create
        # Initializes a new member object from the form parameters associated with the current user's young person.
        @member = current_user.young_person.invites.new(member_params)
        if @member.save
            # Redirects to the member's show page with a success notice if the member is successfully saved.
            redirect_to [@member], notice: 'Member was successfully created.'
        else
            # Renders the new template again with error messages if the member fails to save.
            render :new
        end
    end

    # PATCH/PUT /members/:id
    # Updates an existing member's details.
    def update
        # Updates the member with the new form parameters.
        if @member.update(member_params)
            # Redirects to the member's show page with a success notice if the member is successfully updated.
            redirect_to [@member], notice: 'Member was successfully updated.'
        else
            # Renders the edit template again with error messages if the member update fails.
            render :edit
        end
    end

    # DELETE /members/:id
    # Deletes a specific member.
    def destroy
        # Destroys the member.
        @member.destroy
        # Redirects to the members index page with a success notice after the member is deleted.
        redirect_to members_url, notice: 'Member was successfully destroyed.'
    end

    private
    # Strong parameters method to prevent mass assignment vulnerabilities.
    # Allows only certain attributes to be passed through the form.
    def member_params
        params.require(:member).permit(:name, :email, :phone, :role)
    end
end
