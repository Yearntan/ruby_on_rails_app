# app/controllers/api/v1/questions_controller.rb
# Controller for handling operations on the Question model.
# Provides RESTful methods to create, read, update, and delete questions.

class Api::V1::QuestionsController < ActionController::API
  # Callback to set a question for actions that require finding a question by ID
  before_action :set_question, only: %i[show edit update destroy]

  # GET /questions
  # Retrieves and renders all questions in JSON format.
  def index
    @questions = Question.all
    render json: @questions
  end

  # GET /questions/1
  # Displays a single question.
  def show
  end

  # GET /questions/new
  # Prepares a new question object and fetches all question categories for the form.
  def new
    @question = Question.new
    @ques_categories = QuesCategory.all
  end

  # GET /questions/1/edit
  # Loads a question for editing.
  def edit
  end

  # POST /questions
  # Creates a new Question instance with parameters passed from the form.
  # Redirects to questions listing on success or re-renders the form on failure.
  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to questions_url, notice: 'Question was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /questions/1
  # Updates an existing question and redirects or re-renders based on outcome.
  def update
    if @question.update(question_params)
      redirect_to @question, notice: 'Question was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /questions/1
  # Attempts to destroy a question and handles exceptions.
  def destroy
    begin
      @question.destroy
      redirect_to questions_url, notice: 'Question was successfully destroyed.', status: :see_other
    rescue => e
      Rails.logger.error("Error destroying Question: #{e.message}")
      raise
    end
  end

  private

    # Finds a Question by id from parameters. Used as a before_action filter.
    def set_question
      @question = Question.find(params[:id])
    end

    # Filters and returns only permitted parameters.
    # Ensures only allowed attributes are passed to model.
    def question_params
      params.require(:question).permit(:content, :ques_category_id)
    end
end

