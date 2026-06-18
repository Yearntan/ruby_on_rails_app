# app/controllers/api/v1/answers_controller.rb
# Provides actions for managing answers via API endpoints.

class Api::V1::AnswersController < ActionController::API
  before_action :set_answer, only: [:show, :update, :destroy]
  before_action :authenticate_user!
  before_action :ensure_young_person, only: [:edit, :update, :destroy]

  # GET /api/v1/answers
  # Retrieves answers based on the role of the current user.
  # Returns JSON data containing answers.
  def index
    case current_user.role
    when "loved_one"
      manage_loved_one_access
    when "supporter"
      manage_supporter_access
    when "admin"
      @answers = Answer.all
    else
      render json: { error: "You are not authorized to view this page." }, status: :unauthorized
      return
    end

    render json: @answers
  end

  # GET /api/v1/answers/:id
  # Retrieves details of a specific answer.
  # Returns JSON data containing the answer.
  def show
    render json: @answer
  end

  # POST /api/v1/answers
  # Creates a new answer.
  # Returns JSON data containing the created answer or error messages.
  def create
    # handle_answer_creation
  end

  # PATCH/PUT /api/v1/answers/:id
  # Updates an existing answer.
  # Returns JSON data containing the updated answer or error messages.
  def update
    if @answer.update(answer_params)
      attach_media(@answer, params[:media]) if params[:media].present?
      render json: @answer
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/answers/:id
  # Deletes a specific answer.
  # Returns JSON data confirming the deletion or error messages.
  def destroy
    @answer.media.purge_later
    @answer.destroy
    render json: { message: "Answer was successfully destroyed." }
  end

  private

  # Sets the @answer instance variable for actions that operate on an existing answer.
  def set_answer
    @answer = Answer.find_by(id: params[:id])
    render json: { error: "Answer not found." }, status: :not_found unless @answer
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
      render json: { error: "Files exceed maximum size: #{exceeded_files.map(&:original_filename).join(', ')}" }, status: :unprocessable_entity
      return
    end
  
    record.media.attach(media_files)
  end
  
  # Ensures that only users with appropriate roles can access certain actions.
  def ensure_young_person
    return if current_user.young_person? || current_user.admin? || current_user.supporter?
    render json: { error: "You are not authorized to access this page." }, status: :unauthorized
  end
end
