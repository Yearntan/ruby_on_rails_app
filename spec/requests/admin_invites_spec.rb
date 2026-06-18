require 'rails_helper'

RSpec.describe Admin::InvitesController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:non_admin) { create(:user) }
  let(:invite) { create(:invite) }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe "GET #index" do
    context "as admin" do
      before do
        sign_in admin
        get :index
      end

      it "populates an array of invites" do
        expect(assigns(:invites)).to eq([invite])
      end

      it "renders the :index view" do
        expect(response).to render_template :index
      end
    end

    context "as non-admin" do
      before do
        sign_in non_admin
        get :index
      end

      it "redirects to the root path" do
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Not authorized')
      end
    end
  end

  describe "DELETE #destroy" do
    before { sign_in admin }

    context "when successful" do
      it "deletes the invite" do
        invite
        expect {
          delete :destroy, params: { id: invite.id }
        }.to change(Invite, :count).by(-1)
      end

      it "redirects to invites index with notice" do
        delete :destroy, params: { id: invite.id }
        expect(response).to redirect_to(admin_invites_path)
        expect(flash[:notice]).to eq('Invite was successfully destroyed.')
      end
    end

    context "when not successful" do
      before do
        allow_any_instance_of(Invite).to receive(:destroy).and_return(false)
      end

      it "redirects to invites index with alert" do
        delete :destroy, params: { id: invite.id }
        expect(response).to redirect_to(admin_invites_path)
        expect(flash[:alert]).to eq('Failed to destroy the invite.')
      end
    end
  end

  private

  def sign_in(user)
    # Simulate the sign_in helper from Devise or your authentication framework
    allow(request.env['warden']).to receive(:authenticate!).and_return(user)
    allow(controller).to receive(:current_user).and_return(user)
  end
end
