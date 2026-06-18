require 'rails_helper'

RSpec.describe Api::V1::MembersController, type: :controller do
  let(:user) { create(:user) }
  let(:young_person) { create(:young_person, user: user) }
  let(:member) { create(:member) }
  let(:bubble) { create(:bubble, holder: young_person) }
  let(:bubble_invite) { create(:bubble_invite, bubble: bubble, member: member) }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
    request.headers.merge!({ "Accept" => "application/json" })
  end

  describe 'GET #index' do
    context 'when user is authenticated' do
      it 'returns a list of members' do
        get :index
        expect(response).to have_http_status(:ok)
        expect(json_response['members']).to include(hash_including('id' => member.id))
      end
    end

    context 'when user is not authenticated' do
      before { allow(controller).to receive(:current_user).and_return(nil) }

      it 'returns unauthorized status' do
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #show' do
    context 'when member belongs to young person' do
      it 'shows details of a specific member' do
        get :show, params: { id: bubble_invite.id }
        expect(response).to have_http_status(:ok)
        expect(json_response).to include('id' => member.id)
      end
    end

    context 'when member does not belong to young person' do
      let(:other_member) { create(:member) }

      it 'returns an empty response' do
        get :show, params: { id: other_member.id }
        expect(response).to have_http_status(:ok)
        expect(json_response).to be_empty
      end
    end
  end

  describe 'POST #create' do
    let(:member_params) { { member: { name: 'John Doe', email: 'john@example.com' } } }

    it 'creates a new member' do
      expect { post :create, params: member_params }.to change(BubbleInvite, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    context 'with invalid params' do
      let(:invalid_params) { { member: { name: '', email: 'invalid_email' } } }

      it 'returns an unprocessable entity status' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT/PATCH #update' do
    let(:updated_params) { { id: bubble_invite.id, member: { name: 'Jane Doe' } } }

    it 'updates an existing member' do
      put :update, params: updated_params
      bubble_invite.reload
      expect(bubble_invite.member.name).to eq('Jane Doe')
      expect(response).to have_http_status(:ok)
    end

    context 'with invalid params' do
      let(:invalid_params) { { id: bubble_invite.id, member: { name: '' } } }

      it 'returns an unprocessable entity status' do
        put :update, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes a member' do
      bubble_invite
      expect { delete :destroy, params: { id: bubble_invite.id } }.to change(BubbleInvite, :count).by(-1)
      expect(response).to have_http_status(:ok)
    end

    context 'when deletion fails' do
      before { allow_any_instance_of(BubbleInvite).to receive(:destroy).and_return(false) }

      it 'returns an unprocessable entity status' do
        delete :destroy, params: { id: bubble_invite.id }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end