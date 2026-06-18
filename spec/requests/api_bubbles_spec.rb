# spec/controllers/api/v1/bubbles_controller_spec.rb
require 'rails_helper'

# This is a test suite for the Api::V1::BubblesController
RSpec.describe Api::V1::BubblesController, type: :controller do
  # Create a young person user using the factory and assign it to the variable `young_person_user`
  let(:young_person_user) { create(:user, :young_person) }
  # Retrieve the young person associated with `young_person_user` and assign it to the variable `young_person`
  let(:young_person) { young_person_user.young_person }
  # Create a bubble with `young_person` as the holder and assign it to the variable `bubble`
  let(:bubble) { create(:bubble, holder: young_person) }
  # Create a member user using the factory and assign it to the variable `member`
  let(:member) { create(:user) }
  # Create an admin user using the factory and assign it to the variable `admin`
  let(:admin) { create(:user, :admin) }

  before do
    # Sign in `young_person_user` before each example
    sign_in young_person_user
  end

  describe "GET #index" do
    context "when user is a young person" do
      before do
        # Send a GET request to the `index` action
        get :index
      end

      it "returns the bubbles associated with the young person" do
        # Expect the response status to be `:ok`
        expect(response).to have_http_status(:ok)
        # Expect the response body to be an array of bubbles associated with `young_person`
        expect(JSON.parse(response.body)["bubbles"]).to eq(young_person.bubbles.map { |b| { "id" => b.id, "name" => b.name, "total_members" => b.members.count } })
      end
    end

    context "when user is not authenticated" do
      before do
        # Sign out `young_person_user`
        sign_out young_person_user
        # Send a GET request to the `index` action
        get :index
      end

      it "returns an unauthorized status" do
        # Expect the response status to be `:unauthorized`
        expect(response).to have_http_status(:unauthorized)
        # Expect the response body to contain an error message
        expect(JSON.parse(response.body)["message"]).to eq("User is not a young person")
      end
    end
  end

  describe "GET #show" do
    context "when user is the holder of the bubble" do
      before do
        # Send a GET request to the `show` action with the `id` parameter set to `bubble.id`
        get :show, params: { id: bubble.id }
      end

      it "returns the bubble details" do
        # Expect the response status to be `:ok`
        expect(response).to have_http_status(:ok)
        # Expect the response body to contain the details of the bubble
        expect(JSON.parse(response.body)).to eq({
          "id" => bubble.id,
          "name" => bubble.name,
          "holder_id" => bubble.holder_id,
          "members" => bubble.members.map { |m| { "id" => m.id, "name" => m.name, "email" => m.email } }
        })
      end
    end

    context "when user is not the holder of the bubble" do
      let(:other_user) { create(:user, :young_person) }

      before do
        # Sign in `other_user`
        sign_in other_user
        # Send a GET request to the `show` action with the `id` parameter set to `bubble.id`
        get :show, params: { id: bubble.id }
      end

      it "returns an empty array" do
        # Expect the response status to be `:ok`
        expect(response).to have_http_status(:ok)
        # Expect the response body to be an empty array
        expect(JSON.parse(response.body)).to eq([])
      end
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_attributes) { { name: "New Bubble", holder_id: young_person.id } }

      it "creates a new bubble" do
        # Expect the `Bubble` count to increase by 1 after sending a POST request to the `create` action
        expect {
          post :create, params: { bubble: valid_attributes }
        }.to change(Bubble, :count).by(1)

        # Expect the response status to be `:created`
        expect(response).to have_http_status(:created)
        # Expect the response body to contain the name of the newly created bubble
        expect(JSON.parse(response.body)["name"]).to eq("New Bubble")
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { { name: nil, holder_id: young_person.id } }

      it "does not create a new bubble" do
        # Send a POST request to the `create` action with invalid attributes
        post :create, params: { bubble: invalid_attributes }

        # Expect the response status to be `:bad_request`
        expect(response).to have_http_status(:bad_request)
        # Expect the response body to contain an error message related to the invalid attribute
        expect(JSON.parse(response.body)).to have_key("name")
      end
    end
  end

  describe "PATCH/PUT #update" do
    context "with valid parameters" do
      let(:new_attributes) { { name: "Updated Bubble" } }

      before do
        # Send a PUT request to the `update` action with the `id` parameter set to `bubble.id` and `new_attributes`
        put :update, params: { id: bubble.id, bubble: new_attributes }
        # Reload the `bubble` object from the database
        bubble.reload
      end

      it "updates the bubble" do
        # Expect the name of the `bubble` to be updated to "Updated Bubble"
        expect(bubble.name).to eq("Updated Bubble")
        # Expect the response status to be `:ok`
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { { name: nil } }

      before do
        # Send a PUT request to the `update` action with the `id` parameter set to `bubble.id` and `invalid_attributes`
        put :update, params: { id: bubble.id, bubble: invalid_attributes }
      end

      it "returns a bad request status" do
        # Expect the response status to be `:bad_request`
        expect(response).to have_http_status(:bad_request)
        # Expect the response body to contain an error message related to the invalid attribute
        expect(JSON.parse(response.body)).to have_key("name")
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the bubble" do
      # Create a bubble and expect the `Bubble` count to decrease by 1 after sending a DELETE request to the `destroy` action
      bubble
      expect {
        delete :destroy, params: { id: bubble.id }
      }.to change(Bubble, :count).by(-1)

      # Expect the response status to be `:accepted`
      expect(response).to have_http_status(:accepted)
    end
  end

  describe "POST #assign" do
    before do
      # Set the `bubble_assign_params` variable with the parameters required for the `assign` action
      @bubble_assign_params = { bubble_id: bubble.id, member: { id: member.id } }
    end

    it "assigns a member to the bubble" do
      # Expect the `bubble.members` count to increase by 1 after sending a POST request to the `assign` action
      expect {
        post :assign, params: @bubble_assign_params
      }.to change { bubble.members.count }.by(1)

      # Expect the response status to be `:accepted`
      expect(response).to have_http_status(:accepted)
      # Expect the response body to contain the ID of the assigned member
      expect(JSON.parse(response.body)["members"].map { |m| m["id"] }).to include(member.id)
    end
  end

  describe "POST #unassign" do
    before do
      # Add `member` to the `bubble.members` collection
      bubble.members << member
      # Set the `bubble_unassign_params` variable with the parameters required for the `unassign` action
      @bubble_unassign_params = { bubble_id: bubble.id, member: { id: member.id } }
    end

    it "unassigns a member from the bubble" do
      # Expect the `bubble.members` count to decrease by 1 after sending a POST request to the `unassign` action
      expect {
        post :unassign, params: @bubble_unassign_params
      }.to change { bubble.members.count }.by(-1)

      # Expect the response status to be `:accepted`
      expect(response).to have_http_status(:accepted)
      # Expect the response body not to contain the ID of the unassigned member
      expect(JSON.parse(response.body)["members"].map { |m| m["id"] }).not_to include(member.id)
    end
  end
end
