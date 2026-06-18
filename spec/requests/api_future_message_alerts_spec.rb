require 'rails_helper'

RSpec.describe Api::V1::FutureMessageAlertsController, type: :controller do
  let(:supporter) { create(:user, :supporter) }
  let(:admin) { create(:user, :admin) }
  let(:young_person_user) { create(:user, :young_person) }
  let(:young_person) { create(:young_person, user: young_person_user) }
  let(:future_message) { create(:future_message, user: young_person) }
  let(:future_message_alert) { create(:future_message_alert, future_message: future_message) }
  before do
    sign_in supporter
  end

  describe "GET #index" do
    it "lists all future message alerts for current user's young people" do
      get :index
      expect(response).to have_http_status(:ok)
      expect(json_response['future_message_alerts'].length).to eq(2)
    end
  end

  describe "POST #create" do
    let(:valid_attributes) { { future_message_alert: { future_message_id: future_message.id, commit: "Create Alert" } } }

    it "creates a new FutureMessageAlert" do
      expect {
        post :create, params: valid_attributes
      }.to change(FutureMessageAlert, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it "returns errors with invalid parameters" do
      post :create, params: { future_message_alert: { future_message_id: nil } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET #show" do
    it "shows details of a specific alert" do
      get :show, params: { id: future_message_alert.id }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH/PUT #update" do
    it "updates an existing alert" do
      patch :update, params: { id: future_message_alert.id, future_message_alert: { commit: "Update Alert" } }
      future_message_alert.reload
      expect(future_message_alert.commit).to eq("Update Alert")
      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE #destroy" do
    it "deactivates a future message alert" do
      delete :destroy, params: { id: future_message_alert.id }
      expect(response).to have_http_status(:ok)
      expect(FutureMessageAlert.find_by(id: future_message_alert.id)).to be_nil
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end
