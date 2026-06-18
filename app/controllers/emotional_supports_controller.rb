# app/controllers/invites_controller.rb
# Controller for managing emotional support requests
class EmotionalSupportsController < ApplicationController
  # Display all emotional support requests
  def index
    @emotional_supports = EmotionalSupport.all
  end

  # Render form for creating a new emotional support request
  def new
    @emotional_support = current_user.emotional_supports.build
  end

  # Delete an emotional support request
  def destroy
    @emotional_support.destroy
    redirect_to requests_url, notice: "Request was successfully completed.", status: :see_other
  end

  # Create a new emotional support request
  def create
    @emotional_support = current_user.emotional_supports.build(emotional_support_params)
    if @emotional_support.save
      redirect_to questions_path, notice: 'Support request was successfully created.'
    else
      render :new
    end
  end

  # Mark an emotional support request as completed
  def complete
    @emotional_support = EmotionalSupport.find_by(id: params[:id])
    if @emotional_support.update(status: true)
      redirect_to emotional_supports_path, notice: "Support request was successfully completed.", status: :see_other
    else
      redirect_to emotional_supports_path, notice: "Support request could not be completed.", status: :see_other
    end
  end

  private

  # Parameters for emotional support request
  def emotional_support_params
    params.require(:emotional_support).permit(:content)
  end
end
