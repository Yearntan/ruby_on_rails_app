require 'rails_helper'

RSpec.describe Api::V1::SupporterManagementsController, type: :controller do
    let(:supporter) { create(:user, role: 'supporter') }
    let(:young_person) { create(:user, role: 'young_person') }
    let(:supporter_management) { create(:supporter_management, supporter: supporter, young_person: young_person) }
  
    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
      allow(controller).to receive(:current_user).and_return(supporter)
    end
  
    describe "GET #index" do
      context "when user is a supporter" do
        it "lists all young people for the current supporter" do
          get :index
          expect(response).to have_http_status(:ok)
          # Additional checks as necessary based on your JSON structure
        end
      end
  
      context "when user is not a supporter" do
        it "returns an unauthorized status" do
          allow(controller).to receive(:current_user).and_return(create(:user))
          get :index
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

  describe "GET #show" do
    context "when the record exists" do
      it "shows details of a specific supporter management entry" do
        get :show, params: { id: supporter_management.id }
        expect(response).to have_http_status(:ok)
        expect(json_response).to eq(supporter_management.as_json)  # Customize as per your serializer
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
    let(:valid_attributes) { { young_person_id: young_person.id, status: 'active' } }

    it "creates a new supporter management record" do
      expect {
        post :create, params: { supporter_management: valid_attributes }
      }.to change(SupporterManagement, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    context "with invalid attributes" do
      it "does not create a new supporter management record" do
        post :create, params: { supporter_management: { young_person_id: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH/PUT #update" do
    it "updates the requested supporter management record" do
      put :update, params: { id: supporter_management.id, supporter_management: { status: 'inactive' } }
      supporter_management.reload
      expect(supporter_management.status).to eq('inactive')
      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested supporter management record" do
      supporter_management  # This line ensures the object is created before testing
      expect {
        delete :destroy, params: { id: supporter_management.id }
      }.to change(SupporterManagement, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end
