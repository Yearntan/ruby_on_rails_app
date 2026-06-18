require 'rails_helper'

RSpec.describe Api::V1::YoungPersonManagementsController, type: :controller do
  let(:user) { create(:user, role: 'supporter') }
  let(:young_person) { create(:young_person) }
  let(:management) { create(:young_person_management, supporter: user, young_person: young_person) }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
    request.headers.merge!({ "Accept" => "application/json" })
  end

  describe "GET #index" do
    context "when the user is a supporter" do
      before do
        allow(YoungPersonManagement).to receive(:where).and_return(YoungPersonManagement.where(supporter_id: user.id))
        get :index
      end

      it "lists all managed young people" do
        expect(response).to have_http_status(:ok)
        expect(json_response).to include(young_person.as_json) # Adjust based on your serializer
      end
    end

    context "when the user is not a supporter" do
      before do
        user.role = 'young_person'
        get :index
      end

      it "returns an unauthorized status" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET #show" do
    context "when the record exists and user has permission" do
      before { get :show, params: { id: young_person.id } }

      it "shows details of a managed young person" do
        expect(response).to have_http_status(:ok)
        expect(json_response['young_person']).to be_present
      end
    end

    context "when the record does not exist" do
      it "returns a not found status" do
        get :show, params: { id: 'nonexistent' }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST #create" do
    let(:valid_params) { { young_person_management: { supporter_id: user.id, young_person_id: young_person.id } } }

    it "creates a new management record" do
      expect {
        post :create, params: valid_params
      }.to change(YoungPersonManagement, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    context "when the young person does not exist" do
      it "returns an unprocessable entity status" do
        post :create, params: { young_person_management: { supporter_id: user.id, young_person_id: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "Custom Action #passed_away" do
    context "when the young person exists" do
      it "updates the young person's passed_away status" do
        put :passed_away, params: { user_id: young_person.user_id }
        expect(response).to have_http_status(:ok)
        expect(json_response['success']).to be true
      end
    end

    context "when the young person does not exist" do
      it "returns an unprocessable entity status" do
        put :passed_away, params: { user_id: 'nonexistent' }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end
