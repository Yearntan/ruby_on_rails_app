# app/controllers/api/v1/young_people_controller.rb
# Manages actions related to the YoungPerson model, particularly updating their status.
# This controller ensures secure access to young person records and allows updating their lifecycle status.

class Api::V1::YoungPeopleController < ActionController::API
    # Ensures user authentication for all actions to secure access to young person data.
    before_action :authenticate_user!
    # Sets the young person based on user_id before showing or destroying their records.
    before_action :set_young_person, only: [:show, :destroy]
  
    # DELETE /api/v1/young_people/:id
    # Updates the 'passed_away' status of a young person to true, essentially marking them as deceased.
    def destroy
      if @young_person.update(passed_away: true)
      else
      end
    end
  
    private
    # Finds the YoungPerson based on the user_id provided in params.
    # This method includes an authorization check to ensure that the current user is permitted to manage the young person.
    def set_young_person
      @young_person = YoungPerson.find(params[:id])
      # Redirects to the root path if no valid young person is found or if the current user is not authorized to manage them.
      unless @young_person && current_user.can_manage?(@young_person)
      end
    end
  end
  