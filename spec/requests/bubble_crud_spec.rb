require 'rails_helper'

RSpec.describe 'Bubble Management', type: :request do
    let(:user) { FactoryBot.create(:user, :young_person) }  # Create a young person user
    let(:young_person_1) { FactoryBot.create(:young_person, user: user) }  # Create a young person associated with the user
    let!(:bubble) { FactoryBot.create(:friends_bubble, holder: young_person_1)}  # Create a friends bubble associated with the young person

    describe 'GET /api/v1/bubbles' do
        before do
            login_as user  # Log in as the user
            get '/api/v1/bubbles'  # Send a GET request to retrieve bubbles
        end

        it 'responds with ok status' do
            expect(response).to have_http_status :ok  # Check if the response status is OK
        end

        it 'Have a bubble named friends' do
            expect(response.body).to include(bubble.name)  # Check if the response body includes the name of the bubble
        end
    end

    describe 'GET /api/v1/bubbles/:id' do
        before do
            login_as user  # Log in as the user
            get "/api/v1/bubbles/#{bubble.id}"  # Send a GET request to retrieve a specific bubble
        end

        it 'responds with ok status' do
            expect(response).to have_http_status :ok  # Check if the response status is OK
        end

        it 'shows a bubble with no members' do
            expect(response.body).to include('"members":[]')  # Check if the response body includes an empty array of members
        end
    end

    describe 'POST /api/v1/bubbles' do
        let(:name) { "close_friends" }  # Define the name for the new bubble

        before do
            login_as user  # Log in as the user
            post '/api/v1/bubbles', :params => { :bubble => { name: name, holder_id: young_person_1.id }}  # Send a POST request to create a new bubble
        end

        it 'responds with ok status' do
            expect(response).to have_http_status :created  # Check if the response status is CREATED
        end

        it 'created a new bubble' do
            expect(response.body).to include(name)  # Check if the response body includes the name of the new bubble
        end
    end

    describe 'DELETE /api/v1/bubbles/:id' do
        before do
            login_as user  # Log in as the user
            delete "/api/v1/bubbles/#{bubble.id}"  # Send a DELETE request to delete a specific bubble
        end

        it 'responds with ok status' do
            expect(response).to have_http_status :accepted  # Check if the response status is ACCEPTED
        end

        it 'removes the bubble' do
            expect(response.body).to include('"status":"deleted"')  # Check if the response body includes a status indicating that the bubble was deleted
        end
    end

    describe 'PUT /api/v1/bubbles/:id' do
        let(:new_name) { "found_family" }  # Define the new name for the bubble

        before do
            login_as user  # Log in as the user
            put "/api/v1/bubbles/#{bubble.id}", :params => { :bubble => { name: new_name }}  # Send a PUT request to update the name of a specific bubble
        end

        it 'responds with ok status' do
            expect(response).to have_http_status :ok  # Check if the response status is OK
        end

        it 'removes the bubble' do
            expect(response.body).to include("\"name\":\"#{new_name}\"")  # Check if the response body includes the new name of the bubble
        end
    end
end
