# spec/controllers/invites_controller_spec.rb
require 'rails_helper'

# Describe the InvitesController and specify it's a controller type test
RSpec.describe InvitesController, type: :controller do
  # Create users with different roles for testing
  let(:admin) { create(:user, :admin) }
  let(:supporter) { create(:user, :supporter) }
  let(:young_person) { create(:user, :young_person) }
  let(:loved_one) { create(:user, :loved_one) }

  # Test the new action
  describe "GET #new" do
    context "when authenticated" do
      it "returns a success response" do
        sign_in admin
        get :new
        expect(response).to be_successful
      end
    end

    context "when not authenticated" do
      it "redirects to the sign-in page" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  # Test the create action
  describe "POST #create" do
    # Define valid and invalid attributes for an invite
    let(:valid_attributes) { { email: "test@example.com", role: "supporter", message: "Join us!" } }
    let(:invalid_attributes) { { email: "invalid_email" } }

    context "when authenticated as an admin" do
      before { sign_in admin }

      it "creates a new Invite for a valid role" do
        expect {
          post :create, params: { invite: valid_attributes }
        }.to change(Invite, :count).by(1)
      end

      it "does not create a new Invite for an invalid role" do
        expect {
          post :create, params: { invite: invalid_attributes.merge(role: "loved_one") }
        }.not_to change(Invite, :count)
      end

      it "redirects to the root path on success" do
        post :create, params: { invite: valid_attributes }
        expect(response).to redirect_to(root_path)
      end

      it "renders the new template on failure" do
        post :create, params: { invite: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end

    context "when authenticated as a supporter" do
      before { sign_in supporter }

      it "creates a new Invite for a young person" do
        expect {
          post :create, params: { invite: valid_attributes.merge(role: "young_person") }
        }.to change(Invite, :count).by(1)
      end

      it "does not create a new Invite for an invalid role" do
        expect {
          post :create, params: { invite: invalid_attributes.merge(role: "admin") }
        }.not_to change(Invite, :count)
      end
    end

    context "when authenticated as a young person" do
      before { sign_in young_person }

      it "creates a new Invite for a loved one" do
        expect {
          post :create, params: { invite: valid_attributes.merge(role: "loved_one") }
        }.to change(Invite, :count).by(1)
      end

      it "does not create a new Invite for an invalid role" do
        expect {
          post :create, params: { invite: invalid_attributes.merge(role: "supporter") }
        }.not_to change(Invite, :count)
      end
    end

    context "when authenticated as a loved one" do
      before { sign_in loved_one }

      it "does not create a new Invite" do
        expect {
          post :create, params: { invite: valid_attributes }
        }.not_to change(Invite, :count)
      end
    end
  end
end
