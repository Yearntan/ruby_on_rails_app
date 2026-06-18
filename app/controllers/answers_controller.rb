# app/controllers/answers_controller.rb
# Controller for managing the Answer resources within the application. It handles various
# actions to create, display, update, and delete answers, with specific behaviors based on user roles.

class AnswersController < ApplicationController
  # Set up an answer object for actions that require it, authenticate users, and verify permissions.
  before_action :set_answer, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :ensure_young_person, only: [:edit, :update, :destroy]

  # GET /answers
  # Displays answers based on the role of the current user, implementing role-based access control.
  def index
    case current_user.role
    when "loved_one"
      # Retrieve answers for 'loved_one' role where the associated young person has passed away.
      manage_loved_one_access
    when "supporter"
      # Retrieve answers for a specific young person for 'supporter' role.
      manage_supporter_access
    when "admin"
      # Admins can view all answers.
      @answers = Answer.all
    else
      # Redirect unauthorized users.
      redirect_to root_path, alert: "You are not authorized to view this page."
    end
  end

  # GET /answers/1
  # Shows the details of a specific answer.
  def show
    @question = @answer.question
  end

  # GET /answers/new
  # Prepares a new answer form, fetching necessary associated data.
  def new
    @question = Question.find(params[:question_id])
    @answer = Answer.new
    @bubbles = current_user.young_person.try(:bubbles) || []
  end

  # GET /answers/1/edit
  # Prepares an existing answer for editing.
  def edit
    @question = @answer.question
    @bubbles = current_user.young_person.try(:bubbles) || []
  end

  # POST /answers
  # Creates a new answer from form input.
  def create
    handle_answer_creation
  end

  # PATCH/PUT /answers/1
  # Updates an existing answer with new information from the form.
  def update
    @question = @answer.question
    @bubbles = current_user.young_person.try(:bubbles) || [] # Ensure @bubbles is set

    if @answer.update(answer_params)
      attach_media(@answer, params[:media]) if params[:media].present?
      redirect_to questions_path, notice: "Answer was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /answers/1
  # Removes an answer and its associated media.
  def destroy
    @answer.media.purge_later 
    @answer.destroy
    redirect_to answers_url, notice: "Answer was successfully destroyed.", status: :see_other
  end

  # DELETE /answers/:id/media/:media_id
  # Deletes a specific media item attached to an answer.
  def remove_media
    media_attachment = ActiveStorage::Attachment.find(params[:media_id])
    media_attachment.purge_later
    redirect_back(fallback_location: request.referer, notice: 'Media was successfully removed.')
  end

  private

  # Sets the @answer instance variable for actions that operate on an existing answer.
  def set_answer
    if current_user.role == "young_person"
      @answer = Answer.find_by(id: params[:id],user_id: current_user.id)
    else
      @answer = Answer.find_by(id: params[:id])
    end
  end

  # Whitelists permissible parameters for creating and updating answers.
  def answer_params
    params.require(:answer).permit(:content, :question_id, bubble_ids: [])
  end
  
  # Attaches media files to an answer record while checking for file size constraints.
  def attach_media(record, media_files)
    max_file_size = 10.megabytes
    exceeded_files = media_files.filter { |file| file.size > max_file_size }
  
    if exceeded_files.any?
      flash.now[:alert] = "Files exceed maximum size: #{exceeded_files.map(&:original_filename).join(', ')}"
      render :new and return
    end
  
    record.media.attach(media_files)
  end
  
  # Ensures that only users with appropriate roles can access certain actions.
  def ensure_young_person
    return if current_user.young_person? || current_user.admin? || current_user.supporter?
    redirect_to root_path, alert: "You are not authorized to access this page."
  end

  # Specific access restrictions for admin actions to prevent unauthorized operations.
  def restrict_admin_actions
    forbidden_actions = ['edit', 'update', 'create', 'destroy', 'new']
    if forbidden_actions.include?(action_name)
      redirect_to answers_path, alert: "You are not authorised to perform this action."
    end
  end

  # Helper methods to handle role-specific data fetching logic.
  def manage_loved_one_access
    bm = BubbleMember.find_by(user_id: current_user.id)
    bubble_invites = BubbleInvite.where(bubble_member_id: bm&.id)
    bubbles = bubble_invites.flat_map(&:bubbles)
  
    @answers = bubbles.flat_map do |bubble|
      next unless bubble.holder&.passed_away
  
      answers_bubbles = AnswersBubble.where(bubble_id: bubble.id)
      Answer.where(id: answers_bubbles.pluck(:answer_id))
    end.compact
  end
  

  def manage_supporter_access
    if params[:user_id]
      young_person = YoungPerson.find_by(user_id: params[:user_id])
      if young_person
        @answers = young_person.answers
      else
        redirect_to supporter_dashboard_path, alert: "No young person found."
      end
    else
      redirect_to supporter_dashboard_path, alert: "No young person selected."
    end
  end

  # To handle the multimedia answer and user's answer associated with the question
  def handle_answer_creation
    unless current_user
      flash[:alert] = 'User not found. Please sign in again.'
      redirect_to new_user_session_path and return
    end
  
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params.merge(user_id: current_user.id))
  
    if @answer.save
      attach_media(@answer, params[:media]) if params[:media].present?
      redirect_to questions_path, notice: 'Answer was successfully created.'
    else
      flash.now[:alert] = @answer.errors.full_messages.to_sentence
      render :new
    end
  end
end
