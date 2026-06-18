require 'rails_helper'

RSpec.describe Api::V1::InvitesController, type: :controller do
  let(:admin) { create(:user, role: 'admin') }
  let(:supporter) { create(:user, role: 'supporter') }
  let(:young_person) { create(:user, role: 'young_person') }
  let(:loved_one) { create(:user, role: 'loved_one') }

  describe "POST #create" do
    let(:invite_params) { { invite: { email: 'newuser@example.com', role: 'supporter', message: 'Welcome!' } } }

    context "when user is an admin" do
      before { sign_in admin }

      it "allows creating an invite for supporter" do
        post :create, params: invite_params
        expect(response).to have_http_status(:created)
        expect(json_response['message']).to eq('Invite sent successfully.')
      end

      it "does not allow creating an invite for a young_person" do
        post :create, params: { invite: { email: 'new@example.com', role: 'young_person' } }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user is a supporter" do
      before { sign_in supporter }

      it "allows creating an invite for a young_person" do
        post :create, params: { invite: { email: 'young@example.com', role: 'young_person' } }
        expect(response).to have_http_status(:created)
      end

      it "does not allow creating an invite for another supporter" do
        post :create, params: { invite: { email: 'another@example.com', role: 'supporter' } }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user is a young_person" do
      before { sign_in young_person }

      it "allows creating an invite for a loved_one" do
        post :create, params: { invite: { email: 'loved@example.com', role: 'loved_one' } }
        expect(response).to have_http_status(:created)
      end

      it "does not allow creating an invite for another young_person" do
        post :create, params: { invite: { email: 'peer@example.com', role: 'young_person' } }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user is a loved_one" do
      before { sign_in loved_one }

      it "does not allow creating an invite for anyone" do
        post :create, params: { invite: { email: 'anyone@example.com', role: 'young_person' } }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end
