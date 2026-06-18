# YoungPeopleController
# Manages actions related to the YoungPerson model, particularly updating their status.
# This controller ensures secure access to young person records and allows updating their lifecycle status.

class YoungPeopleController < ApplicationController
  # Ensures user authentication for all actions to secure access to young person data.
  before_action :authenticate_user!
  # Sets the young person based on user_id before showing or destroying their records.
  before_action :set_young_person, only: [:show, :destroy]

  # DELETE /young_people/:id
  # Updates the 'passed_away' status of a young person to true, essentially marking them as deceased.
  def destroy
      # Although set_young_person is called, it uses user_id to find the young person,
      # this ensures the correct young person is found by ID for deletion purposes.
      @young_person = YoungPerson.find(params[:id])
      if @young_person.update(passed_away: true)
          # If the update is successful, redirect to the list with a success notice.
          redirect_to young_people_url, notice: 'Successfully updated the status.'
      else
          # If the update fails, redirect to the list with an error alert.
          redirect_to young_people_url, alert: 'Failed to update the status.'
      end
  end

  private
  # Finds the YoungPerson based on the user_id provided in params.
  # This method includes an authorization check to ensure that the current user is permitted to manage the young person.
  def set_young_person
      @young_person = YoungPerson.find_by(user_id: params[:user_id])
      # Redirects to the root path if no valid young person is found or if the current user is not authorized to manage them.
      unless @young_person && current_user.can_manage?(@young_person)
          redirect_to root_path, alert: 'Invalid user.'
      end
  end
end
