require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  let(:user) { create(:user, email: 'user@example.com', password: 'Password123') }

  describe "POST #create" do
    context "with valid credentials" do
      it "logs in the user" do
        post :create, params: { session: { email: user.email, password: 'Password123' } }
        expect(response).to have_http_status(:ok)
        expect(json_response['success']).to be_truthy
        expect(json_response['message']).to eq('You have been logged in')
        expect(session[:user_id]).to eq(user.id)
      end
    end

    context "with invalid credentials" do
      it "does not log in the user" do
        post :create, params: { session: { email: user.email, password: 'wrong' } }
        expect(response).to have_http_status(:unauthorized)
        expect(json_response['success']).to be_falsey
        expect(json_response['error']).to eq('Invalid email/password combination')
        expect(session[:user_id]).to be_nil
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      post :create, params: { session: { email: user.email, password: 'Password123' } }
    end

    it "logs out the user" do
      delete :destroy
      expect(response).to have_http_status(:ok)
      expect(json_response['success']).to be_truthy
      expect(json_response['message']).to eq('You have been logged out')
      expect(session[:user_id]).to be_nil
    end
  end

  private

  # Helper to parse JSON responses
  def json_response
    JSON.parse(response.body)
  end
end
