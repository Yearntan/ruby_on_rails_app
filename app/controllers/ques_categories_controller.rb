# app/controllers/ques_categories_controller.rb
# Manages the CRUD operations for question categories within the application.
# This controller handles actions like listing, showing, creating, updating, and deleting question categories.

class QuesCategoriesController < ApplicationController
  # Ensures that a question category is set before showing, editing, updating, or destroying it.
  before_action :set_ques_category, only: [:show, :edit, :update, :destroy]

  # GET /ques_categories
  # Displays all question categories.
  def index
    @ques_categories = QuesCategory.all
  end

  # GET /ques_categories/1
  # Shows details of a specific question category. 
  # This method may seem redundant as it does not add additional logic, but it supports the RESTful pattern.
  def show
  end

  # GET /ques_categories/new
  # Initializes a new question category for creation.
  def new
    @ques_category = QuesCategory.new
  end

  # GET /ques_categories/1/edit
  # Loads a question category for editing.
  def edit
  end

  # POST /ques_categories
  # Creates a new question category from the provided form parameters.
  def create
    @ques_category = QuesCategory.new(ques_category_params)
    if @ques_category.save
      redirect_to ques_categories_path, notice: "Ques category was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ques_categories/1
  # Updates an existing question category with new information from the form.
  def update
    if @ques_category.update(ques_category_params)
      redirect_to ques_categories_path, notice: "Question category was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /ques_categories/1
  # Deletes a question category and handles any exceptions if the deletion fails.
  def destroy
    @ques_category.destroy!
    redirect_to ques_categories_url, notice: "Ques category was successfully destroyed.", status: :see_other
  rescue ActiveRecord::RecordNotDestroyed
    redirect_to ques_categories_url, alert: "Ques category could not be destroyed. Please ensure there are no dependent records."
  end

  private
    # Finds the question category based on the ID provided in params. Used in various actions.
    def set_ques_category
      @ques_category = QuesCategory.find(params[:id])
    end

    # Strong parameters: allows only specific parameters to pass through to prevent mass assignment vulnerabilities.
    def ques_category_params
      params.require(:ques_category).permit(:name, :active)
    end
end
