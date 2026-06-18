require 'rails_helper'

RSpec.describe Api::V1::EmotionalSupportsController, type: :controller do
  let(:user) { create(:user) }
  let(:emotional_support) { create(:emotional_support, user: user) }
  let(:valid_attributes) { { content: 'I need help' } }
  let(:invalid_attributes) { { content: '' } }
  before do
    sign_in user  # Assuming you're using Devise for authentication
  end

  describe "GET #index" do
    it "retrieves all emotional support requests" do
      get :index
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(3)
    end
  end

  describe "POST #create" do
    context "with valid params" do
        let(:valid_attributes) { { emotional_support: { content: 'I need support' } } }

        it "creates a new EmotionalSupport" do
            expect {
                post :create, params: valid_attributes
            }.to change(EmotionalSupport, :count).by(1)
            expect(response).to have_http_status(:created)
        end

        it "returns error when parameters are invalid" do
            post :create, params: { emotional_support: { content: "" } } # Assuming presence validation on content
            expect(response).to have_http_status(:unprocessable_entity)
        end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the emotional support request" do
        emotional_support = create(:emotional_support, user: user)
        expect {
        delete :destroy, params: { id: emotional_support.id }
      }.to change(EmotionalSupport, :count).by(-1)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH/PUT #complete" do
    it "marks the emotional support request as completed" do
      patch :complete, params: { id: emotional_support.id }
      emotional_support.reload
      expect(emotional_support.status).to be true
      expect(response).to have_http_status(:ok)
    end
  end
  
  private

  def json_response
    JSON.parse(response.body)
  end
end
