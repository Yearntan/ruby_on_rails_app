require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:supporter) { create(:user, :supporter) }
  let(:young_person) { create(:user, :young_person) }
  let(:question) { create(:question) }
  
  # Create a QuesCategory before each test
  let(:ques_category) { create(:ques_category)}

  # Define valid and invalid attributes for testing
  let(:valid_attributes) {
    { content: 'What is RSpec?', ques_category_id: ques_category.id, sensitivity: 'false', active: 'true'}
  }

  let(:invalid_attributes) {
    { content: '', ques_category_id: nil }
  }

  # Set up a user and sign them in before each test
  before do
    user = create(:user)
    sign_in user
  end

  # Test the index action
  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  # Test the show action
  describe "GET #show" do
    it "returns a success response" do
      question = create(:question, valid_attributes)
      get :show, params: { id: question.id }
      expect(response).to be_successful
    end
  end

  # Test the create action
  describe "POST #create" do
    context "with valid params" do
      it "creates a new Question" do
        expect {
          post :create, params: { question: valid_attributes }
        }.to change(Question, :count).by(1)
      end

      it "redirects to the questions list" do
        post :create, params: { question: valid_attributes }
        expect(response).to redirect_to(questions_path)
      end
    end

    context "with invalid params" do
      it "does not create a new Question and redirects to the new question form" do
        post :create, params: { question: invalid_attributes }
        expect(response).to redirect_to(new_question_path)
        expect(Question.count).to eq(0)
        expect(flash[:alert]).to be_present
      end
    end
  end

  # Test the update action
  describe "PUT #update" do
    context "with valid params" do
      it "updates the requested question" do
        question = create(:question, valid_attributes)
        put :update, params: { id: question.id, question: valid_attributes.merge(content: 'Updated content') }
        question.reload
        expect(question.content).to eq('Updated content')
      end

      it "redirects to the questions list" do
        question = create(:question, valid_attributes)
        put :update, params: { id: question.id, question: valid_attributes.merge(content: 'Updated content') }
        expect(response).to redirect_to(questions_path)
      end
    end

    context "with invalid params" do
      it "renders the edit template" do
        question = create(:question, valid_attributes)
        put :update, params: { id: question.id, question: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)  
      end
    end
  end

  # Test the destroy action
  describe "DELETE #destroy" do
    it "soft deletes the requested question" do
      question = create(:question, valid_attributes.merge(active: false))
      delete :destroy, params: { id: question.id }
      question.reload
      expect(question.active).to be_falsey
    end

    it "redirects to the questions list" do
      question = create(:question, valid_attributes.merge(active: false))
      delete :destroy, params: { id: question.id }
      expect(response).to redirect_to(questions_url(host: 'test.host'))
    end
  end


  describe "GET #index" do
    context "as an admin" do
      it "returns a success response" do
        get :index
        expect(response).to be_successful
      end
    end

    context "as a supporter" do
      before { sign_in supporter }
      it "returns a success response" do
        get :index
        expect(response).to be_successful
      end
    end

    context "as a young person" do
      before { sign_in young_person }
      it "returns a success response" do
        get :index
        expect(response).to be_successful
      end

      it "filters questions based on support requests" do
        create(:emotional_support, user: young_person, status: true)
        get :index
        expect(assigns(:questions)).not_to be_empty
      end
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: question.id }
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: { id: question.id }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new Question" do
        expect {
          post :create, params: { question: valid_attributes }
        }.to change(Question, :count).by(1)
      end

      it "redirects to the questions path" do
        post :create, params: { question: valid_attributes }
        expect(response).to redirect_to(questions_path)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Question" do
        expect {
          post :create, params: { question: invalid_attributes }
        }.to change(Question, :count).by(0)
      end

      it "renders the new template" do
        post :create, params: { question: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      let(:new_attributes) {
        { content: "Updated content", ques_category_id: create(:ques_category).id }
      }

      it "updates the requested question" do
        patch :update, params: { id: question.id, question: new_attributes }
        question.reload
        expect(question.content).to eq("Updated content")
      end

      it "redirects to the questions path" do
        patch :update, params: { id: question.id, question: new_attributes }
        expect(response).to redirect_to(questions_path)
      end
    end

    context "with invalid parameters" do
      it "renders the edit template" do
        patch :update, params: { id: question.id, question: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    it "soft-deletes the requested question" do
      question = create(:question)
      expect {
        delete :destroy, params: { id: question.id }
      }.to change { Question.where(active: false).count }.by(1)
    end

    it "redirects to the questions list" do
      question = create(:question)
      delete :destroy, params: { id: question.id }
      expect(response).to redirect_to(questions_path)
    end
  end

  describe "POST #request_change" do
    it "marks the question as requesting a change" do
      post :request_change, params: { id: question.id }
      question.reload
      expect(question.change).to be true
      expect(response).to redirect_to(question)
    end
  end

  describe "POST #deactivate" do
    it "deactivates the question" do
      post :deactivate, params: { id: question.id }
      question.reload
      expect(question.active).to be false
      expect(response).to redirect_to(questions_path)
    end
  end

  describe "POST #activate" do
    it "activates the question" do
      question.update(active: false)
      post :activate, params: { id: question.id }
      question.reload
      expect(question.active).to be true
      expect(response).to redirect_to(questions_path)
    end
  end
end
