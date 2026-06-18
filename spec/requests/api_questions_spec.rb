require 'rails_helper'

RSpec.describe Api::V1::QuestionsController, type: :controller do
  let(:valid_attributes) {
    { content: 'How does photosynthesis work?', ques_category_id: create(:ques_category).id }
  }

  let(:invalid_attributes) {
    { content: '', ques_category_id: nil }
  }

  let(:question) { create(:question) }

  describe "GET #index" do
    it "returns a success response" do
      question
      get :index
      expect(response).to be_successful
      expect(response.content_type).to match(a_string_including("application/json"))
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: question.id }
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "assigns a new question as @question" do
      get :new
      expect(assigns(:question)).to be_a_new(Question)
    end
  end

  describe "GET #edit" do
    it "assigns the requested question as @question" do
      get :edit, params: { id: question.id }
      expect(assigns(:question)).to eq(question)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Question and returns a JSON format" do
        expect {
          post :create, params: { question: valid_attributes }, as: :json
        }.to change(Question, :count).by(1)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid params" do
      it "does not create a new Question and returns errors in JSON format" do
        expect {
          post :create, params: { question: invalid_attributes }, as: :json
        }.to change(Question, :count).by(0)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { content: 'Updated content' }
      }

      it "updates the requested question" do
        put :update, params: { id: question.id, question: new_attributes }
        question.reload
        expect(question.content).to eq('Updated content')
      end

      it "redirects to the question" do
        put :update, params: { id: question.id, question: valid_attributes }
        expect(response).to redirect_to(question)
        expect(flash[:notice]).to match('Question was successfully updated.')
      end
    end

    context "with invalid params" do
      it "returns a failure response (to re-render 'edit')" do
        put :update, params: { id: question.id, question: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested question" do
      question
      expect {
        delete :destroy, params: { id: question.id }
      }.to change(Question, :count).by(-1)
    end

    it "redirects to the questions list" do
      delete :destroy, params: { id: question.id }
      expect(response).to redirect_to(questions_url)
      expect(flash[:notice]).to match('Question was successfully destroyed.')
    end
  end
end
