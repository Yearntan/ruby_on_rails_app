# app/controllers/questions_controller.rb
# Manages CRUD operations for questions within the application.
# This includes displaying, creating, updating, deactivating, and requesting changes for questions.
# Access control is enforced, particularly restricting certain actions to admins or other authorized roles.

class QuestionsController < ApplicationController
  # Ensures user authentication for all actions.
  before_action :authenticate_user!
  # Sets a question for actions that require an existing question instance.
  before_action :set_question, only: %i[show edit update destroy]
  # Ensures that only authorized users can access certain actions.
  before_action :ensure_authorized_for_action, only: [:index, :show, :edit, :destroy, :update]

  # GET /questions
  # Lists all questions, with admins seeing all and others seeing only active questions.
  def index
    if current_user.young_person?
      support_requests = EmotionalSupport.where(user_id: current_user.id, status: true)
      if support_requests.empty?
        @questions = Question.where(active: true, sensitivity: false)
      else
        @questions = Question.where(active: true)
      end
    elsif current_user.admin?
      @questions = Question.all
    elsif current_user.supporter?
      @questions = Question.all
    else
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end
  

  # GET /questions/1
  # Displays a single question.
  def show
  end

  # GET /questions/new
  # Prepares a new question form with all question categories.
  def new
    @question = Question.new
    @ques_categories = QuesCategory.all
  end

  # GET /questions/1/edit
  # Prepares an existing question for editing, including loading all question categories.
  def edit
    @ques_categories = QuesCategory.all
  end

  # POST /questions
  # Attempts to create a new question with parameters provided via the form.
  def create
    @question = Question.new(question_params)

    # Validates necessary inputs before saving.
    if @question.ques_category_id.nil?
      redirect_to new_question_path, alert: "Question category is required" and return 
    end
    
    if @question.content.strip.empty?
      redirect_to new_question_path, alert: "Question content is required" and return 
    end

    if @question.save
      redirect_to questions_path, notice: "Question was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /questions/1
  # Updates an existing question with new data from the form.
  def update
    @ques_categories = QuesCategory.all
    if @question.update(question_params)
      redirect_to questions_path, notice: "Question was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /questions/1
  # Deactivates a question, effectively soft-deleting it.
  def destroy
    if @question.update(active: false)
      redirect_to questions_path, notice: "Question was successfully deactivated."
    else
      flash[:alert] = "Failed to deactivate question."
      redirect_to questions_path
    end
  end

  # Custom action to mark a question as requesting a change.
  def request_change
    @question = Question.find(params[:id])
    @question.update(change: true)
    redirect_to @question, notice: 'Change request submitted successfully'
  end

  # Action to deactive the question
  def deactivate
    @question = Question.find(params[:id])
    if @question.update(active: false)
      redirect_to questions_path, notice: 'Question was successfully deactivated.'
    else
      flash[:alert] = 'Failed to deactivate question.'
      redirect_to questions_path
    end
  end

  # Action to activate the question
  def activate
    @question = Question.find(params[:id])
    if @question.update(active: true)
      redirect_to questions_path, notice: 'Question was successfully activated.'
    else
      flash[:alert] = 'Failed to activate question.'
      redirect_to questions_path
    end
  end


  private
    # Finds the question based on the ID provided in params, used in various actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Allows only specific, safe parameters to pass through to the model to prevent mass assignment vulnerabilities.
    def question_params
      params.require(:question).permit(:content, :ques_category_id, :sensitivity, :active)
    end

    # Ensures that only users with appropriate roles can access certain actions based on the context of the action.
    def ensure_authorized_for_action
      case action_name.to_sym
      when :index, :show
        unless current_user.admin? || current_user.supporter? || current_user.young_person?
          redirect_to root_path, alert: "You are not authorized to access this page."
        end
      when :edit, :destroy, :update
        unless current_user.admin?
          redirect_to root_path, alert: "You are not authorized to access this page."
        end
      end
    end
end
