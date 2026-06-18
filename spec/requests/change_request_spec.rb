# spec/controllers/change_requests_controller_spec.rb
# Require rails_helper to load necessary configurations for RSpec
require 'rails_helper'

# Describe the ChangeRequestsController and specify it's a controller type test
RSpec.describe ChangeRequestsController, type: :controller do
  # Define a let block to create a question instance using FactoryBot
  let(:question) { FactoryBot.create(:question) }
  # Define a let block to create a user instance using FactoryBot
  let(:user) { FactoryBot.create(:user) }  # Assuming a User factory exists

  # Define valid attributes for a change request
  let(:valid_attributes) {
    { content: 'Need to update this question.', status: 'pending', question_id: question.id }
  }
  # Define invalid attributes for a change request
  let(:invalid_attributes) {
    { content: '', status: '', question_id: nil }
  }

  # Before each test, sign in the user
  before do
    sign_in user
  end

  # Test the index action
  describe "GET #index" do
    # Test if the index action renders a successful response
    it "renders a successful response" do
      ChangeRequest.create! valid_attributes
      get :index
      expect(response).to be_successful 
    end
  end

  # Test the show action
  describe "GET #show" do
    # Test if the show action renders a successful response
    it "renders a successful response" do
      change_request = ChangeRequest.create! valid_attributes
      get :show, params: { id: change_request.id }
      expect(response).to be_successful
    end
  end

  # Test the new action
  describe "GET #new" do
    # Test if the new action renders a successful response
    it "renders a successful response" do
      get :new, params: { question_id: question.id }
      expect(response).to be_successful
    end
  end

  # Test the create action
  describe "POST #create" do
    # Test creation with valid parameters
    context "with valid parameters" do
      it "creates a new ChangeRequest and redirects to the question list" do
        expect {
          post :create, params: { question_id: question.id, change_request: valid_attributes }
        }.to change(ChangeRequest, :count).by(1)
        expect(response).to redirect_to(questions_path)
      end
    end

    # Test creation with invalid parameters
    context "with invalid parameters" do
      it "does not create a new ChangeRequest and re-renders the 'new' template" do
        expect {
          post :create, params: { question_id: question.id, change_request: invalid_attributes }
        }.not_to change(ChangeRequest, :count)
        expect(response).to render_template(:new)
      end
    end
  end

  # Test the destroy action
  describe "DELETE #destroy" do
    it "destroys the requested change_request and redirects to the list" do
      change_request = ChangeRequest.create! valid_attributes
      expect {
        delete :destroy, params: { question_id: question.id, id: change_request.id }
      }.to change(ChangeRequest, :count).by(-1)
      expect(response).to redirect_to(change_requests_path)
    end
  end
end
