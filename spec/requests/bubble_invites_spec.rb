require 'rails_helper'

RSpec.describe BubbleInvitesController, type: :controller do
  let(:user) { create(:user) }
  let(:bubble_member) { create(:bubble_member, user: user) }
  let(:bubble_invite) { create(:bubble_invite, bubble_member: bubble_member, status: :pending) }

  before do
    sign_in user
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    context "when bubble_member exists" do
      before do
        allow(user).to receive(:bubble_member).and_return(bubble_member)
        get :index
      end

      it "assigns @invites with pending invites" do
        expect(assigns(:invites)).to eq([bubble_invite])
      end

      it "renders the index template" do
        expect(response).to render_template(:index)
      end
    end

    context "when bubble_member does not exist" do
      before do
        allow(user).to receive(:bubble_member).and_return(nil)
        get :index
      end

      it "assigns @invites as an empty array" do
        expect(assigns(:invites)).to eq([])
      end

      it "renders the index template" do
        expect(response).to render_template(:index)
      end
    end
  end

  describe "PATCH #accept" do
    context "when accepting an invite" do
      before do
        patch :accept, params: { id: bubble_invite.id }
        bubble_invite.reload
      end

      it "updates the invite status to accepted" do
        expect(bubble_invite.status).to eq("accepted")
      end

      it "associates the invite with bubbles and members" do
        bubble_invite.bubbles.each do |bubble|
          expect(bubble.members).to include(bubble_invite)
        end
      end

      it "creates a bubble_member if none exists" do
        expect(bubble_invite.bubble_member).not_to be_nil
      end

      it "redirects to bubble_invites_path with a notice" do
        expect(response).to redirect_to(bubble_invites_path)
        expect(flash[:notice]).to eq('Invitation accepted.')
      end
    end
  end

  describe "PATCH #reject" do
    context "when rejecting an invite" do
      before do
        patch :reject, params: { id: bubble_invite.id }
        bubble_invite.reload
      end

      it "updates the invite status to rejected" do
        expect(bubble_invite.status).to eq("rejected")
      end

      it "redirects to bubble_invites_path with a notice" do
        expect(response).to redirect_to(bubble_invites_path)
        expect(flash[:notice]).to eq('Invitation rejected.')
      end
    end
  end
end
