require 'rails_helper'

RSpec.describe Api::V1::ChangeRequestsController, type: :controller do
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
  before do
    sign_in user  # Assuming `admin` has permissions for all actions
  end

  describe "GET #index" do
    before do
      create_list(:change_request, 3, question: question)
      get :index
    end

    it "returns all change requests" do
      expect(response).to have_http_status(:ok)
      expect(json_response['change_requests'].size).to eq(3)
    end
  end

  describe "GET #show" do

    it "returns details of a specific change request" do
      change_request = ChangeRequest.create! valid_attributes
      get :show, params: { id: change_request.id }
      expect(response).to have_http_status(:ok)
      expect(json_response['content']).to eq(change_request.content)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_params) { { question_id: question.id, change_request: { content: "Updated content", status: "new" } } }

      it "creates a new change request" do
        expect {
          post :create, params: valid_params
        }.to change(ChangeRequest, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) { { question_id: question.id, change_request: { content: "", status: "new" } } }

      it "does not create a change request" do
        expect {
          post :create, params: invalid_params
        }.to change(ChangeRequest, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the change request" do
        change_request = ChangeRequest.create! valid_attributes
    expect {
        delete :destroy, params: { question_id: question.id, id: change_request.id }
      }.to change(ChangeRequest, :count).by(-1)
      expect(response).to have_http_status(:ok)
    end
  end
 

  private

  def json_response
    JSON.parse(response.body)
  end
end
