require 'rails_helper'

# Context for assigning members to a bubble
context 'assigning members' do
    # Create necessary user and bubble data
    let!(:user) { FactoryBot.create(:user, :young_person) }
    let!(:young_person_1) { FactoryBot.create(:young_person, user: user) }
    let!(:bubble) { FactoryBot.create(:friends_bubble, holder: young_person_1)}
    # Create a bubble member for testing
    let!(:bubble_member_1) { FactoryBot.create(:bubble_invite, young_person: young_person_1) }

    # Test the endpoint for assigning a member to a bubble
    describe 'POST /api/v1/bubbles/:id/assign' do
        before do
            login_as user
            # Assign the member to the bubble
            post "/api/v1/bubbles/#{bubble.id}/assign", :params => { :member => { id: bubble_member_1.id }}
        end

        it 'responds with accepted status' do
            expect(response).to have_http_status :accepted
        end

        it 'adds the member' do
            expect(response.body).to include("\"name\":\"#{bubble_member_1.name}\"")
        end
    end

    # Test the endpoint for unassigning a member from a bubble
    describe 'POST /api/v1/bubbles/:id/unassign' do
        before do
            # Add the member to the bubble before unassigning
            bubble.members << bubble_member_1
            login_as user
            # Unassign the member from the bubble
            post "/api/v1/bubbles/#{bubble.id}/unassign", :params => { :member => { id: bubble_member_1.id }}
        end

        it 'responds with accepted status' do
            expect(response).to have_http_status :accepted
        end

        it 'removes the member' do
            expect(response.body).to include('"members":[]')
        end
    end
end
