# app/controllers/api/v1/ques_categories_controller.rb
# Controller for managing Question Categories through API endpoints.
# Supports CRUD operations on question categories, which are used to categorize questions.
class Api::V1::QuesCategoriesController < ActionController::API

    # Sets up a question category object for actions that require it
    before_action :set_ques_category, only: [:show, :update, :destroy]

    # GET /api/v1/ques_categories
    # Retrieves all question categories and renders them as JSON.
    def index
        @ques_categories = QuesCategory.all
        render json: @ques_categories
    end

    # GET /api/v1/ques_categories/:id
    # Displays a specific question category based on its ID.
    # Renders the category details as JSON.
    def show
        render json: @ques_category
    end

    # POST /api/v1/ques_categories
    # Creates a new question category from provided parameters.
    # Returns the created category as JSON if successful, or errors if unsuccessful.
    def create
        @ques_category = QuesCategory.new(ques_category_params)

        if @ques_category.save
            render json: @ques_category, status: :created, location: api_v1_ques_category_url(@ques_category)
        else
            render json: @ques_category.errors, status: :unprocessable_entity
        end
    end

    # PATCH/PUT /api/v1/ques_categories/:id
    # Updates an existing question category with provided parameters.
    # Renders the updated category as JSON if successful, or errors if unsuccessful.
    def update
        if @ques_category.update(ques_category_params)
            render json: @ques_category, status: :ok
        else
            render json: @ques_category.errors, status: :unprocessable_entity
        end
    end

    # DELETE /api/v1/ques_categories/:id
    # Attempts to delete a specific question category.
    # Returns no content if successful, or an error message if there are dependent records preventing deletion.
    def destroy
        begin
            @ques_category.destroy!
            head :no_content
        rescue ActiveRecord::RecordNotDestroyed
            render json: { error: "Ques category could not be destroyed. Please ensure there are no dependent records." }, status: :conflict
        end
    end

    private

    # Finds the question category based on the ID from URL parameters.
    def set_ques_category
        @ques_category = QuesCategory.find(params[:id])
    end

    # Sanitizes input parameters for creating and updating question categories.
    def ques_category_params
        params.require(:ques_category).permit(:name, :active)
    end
end
