require 'rails_helper'

RSpec.describe InvitesController, type: :controller do
  let(:admin) { create(:user, role: 'admin') }
  let(:supporter) { create(:user, role: 'supporter') }
  let(:young_person) { create(:user, role: 'young_person') }
  let(:loved_one) { create(:user, role: 'loved_one') }

  describe "GET #new" do
    before do
      sign_in admin  # Assume the user must be signed in to access this action
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
      expect(assigns(:invite)).to be_a_new(Invite)
    end
  end

  describe "POST #create" do
    context "as admin" do
      before { sign_in admin }

      it "creates and sends an invitation to a supporter" do
        expect {
          post :create, params: { invite: { email: 'supporter@example.com', role: 'supporter', message: 'Join us!' } }
        }.to change(Invite, :count).by(1)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Invite sent successfully.')
      end

      it "prevents creating an invitation for a role not permitted" do
        post :create, params: { invite: { email: 'user@example.com', role: 'young_person', message: 'Welcome!' } }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You are not authorized to invite this type of user.")
      end
    end

    context "as supporter" do
      before { sign_in supporter }

      it "allows creating an invite for a young person" do
        post :create, params: { invite: { email: 'young@example.com', role: 'young_person', message: 'Welcome!' } }
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Invite sent successfully.')
      end

      it "does not allow inviting a supporter" do
        post :create, params: { invite: { email: 'another@example.com', role: 'supporter' } }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You are not authorized to invite this type of user.")
      end
    end

    context "as young person" do
      before { sign_in young_person }

      it "allows creating an invite for a loved one" do
        post :create, params: { invite: { email: 'loved@example.com', role: 'loved_one' } }
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Invite sent successfully.')
      end

      it "does not allow inviting another young person" do
        post :create, params: { invite: { email: 'peer@example.com', role: 'young_person' } }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You are not authorized to invite this type of user.")
      end
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end
