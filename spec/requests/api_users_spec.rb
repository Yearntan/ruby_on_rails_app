require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:young_person) { create(:user, role: 'young_person') } # Assuming a role-based setup in the User model
  let(:management) { create(:management, young_person: young_person) }

  describe "GET #show" do
    context "when the user exists" do
      it "returns user details" do
        get :show, params: { id: user.id }
        expect(response).to have_http_status(:ok)
        expect(json_response['user']['id']).to eq(user.id)
      end
    end

    context "when the user does not exist" do
      it "returns a not found status" do
        get :show, params: { id: 0 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET #index" do
    it "lists all users" do
      get :index
      expect(response).to have_http_status(:ok)
      expect(json_response).to be_an_instance_of(Array)
    end
  end

  describe "POST #create" do
    let(:valid_attributes) { { user: { name: 'New User', email: 'newuser@example.com', role: 'user', token: 'valid_token' } } }
    let(:invalid_attributes) { { user: { name: '', email: 'bademail', role: 'user', token: 'expired_token' } } }

    context "with valid parameters" do
      it "creates a new User" do
        expect {
          post :create, params: valid_attributes
        }.to change(User, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      it "does not create a new User" do
        expect {
          post :create, params: invalid_attributes
        }.not_to change(User, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT #update" do
    context "with valid parameters" do
      let(:new_attributes) { { user: { name: 'Updated Name' } } }

      it "updates the requested user" do
        put :update, params: { id: user.id, user: new_attributes }
        user.reload
        expect(user.name).to eq('Updated Name')
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid parameters" do
      it "does not update the user" do
        put :update, params: { id: user.id, user: { email: 'invalidemail' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested user" do
      user = create(:user)
      expect {
        delete :destroy, params: { id: user.id }
      }.to change(User, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end

  private

  # Helper to parse JSON responses
  def json_response
    JSON.parse(response.body)
  end
end
