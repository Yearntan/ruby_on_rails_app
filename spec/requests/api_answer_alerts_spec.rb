require 'rails_helper'

# This spec file tests the functionality of the Api::V1::AnswerAlertsController

RSpec.describe Api::V1::AnswerAlertsController, type: :controller do
  let(:user) { create(:user) } # Create a user using the factory
  let(:young_person) { create(:young_person, user: user) } # Create a young person associated with the user
  let(:answer) { create(:answer, young_person: young_person, user_id: user.id) } # Create an answer associated with the young person and user
  let(:answer_alert) { create(:answer_alert, answer: answer) } # Create an answer alert associated with the answer
  
  before do
    sign_in user  # Sign in the user
  end

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true) # Allow the controller to receive the authenticate_user! method and return true
    allow(controller).to receive(:current_user).and_return(user) # Allow the controller to receive the current_user method and return the user
  end

  describe "GET #index" do
    it "returns a list of answer alerts" do
      get :index
      expect(response).to be_successful
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(json_response['answer_alerts'].size).to eq(1)
    end
  end

  describe "GET #show" do
    it "returns a specific answer alert" do
      get :show, params: { id: answer_alert.id }
      expect(response).to be_successful
      expect(json_response['id']).to eq(answer_alert.id)
    end
  end

  describe "POST #create" do
    let(:valid_attributes) {
      { answer_id: answer.id, commit: 'High' } # Set valid attributes for creating an answer alert
    }

    it "creates a new answer alert" do
      expect {
        post :create, params: { answer_alert: valid_attributes } # Create a new answer alert with the valid attributes
      }.to change(AnswerAlert, :count).by(1) # Expect the count of answer alerts to increase by 1
      expect(response).to have_http_status(:created)
    end

    it "returns errors for invalid parameters" do
      post :create, params: { answer_alert: { answer_id: nil } } # Create an answer alert with invalid parameters
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH/PUT #update" do
    let(:new_attributes) {
      { commit: 'Medium' } # Set new attributes for updating an answer alert
    }

    it "updates an answer alert" do
      patch :update, params: { id: answer_alert.id, answer_alert: new_attributes } # Update the answer alert with the new attributes
      answer_alert.reload
      expect(answer_alert.commit).to eq('Medium') # Expect the commit attribute of the answer alert to be updated
      expect(response).to be_successful
    end
  end

  describe "DELETE #destroy" do
    it "sets answer alert to inactive" do
      delete :destroy, params: { id: answer_alert.id } # Delete the answer alert
      expect(response).to have_http_status(:no_content)
      answer_alert.reload
      expect(answer_alert.active).to be_falsey # Expect the active attribute of the answer alert to be set to false
    end
  end

  def json_response
    JSON.parse(response.body) # Parse the response body as JSON
  end
end
