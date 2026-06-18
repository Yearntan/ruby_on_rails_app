require 'rails_helper'

RSpec.describe Api::V1::ContactsController, type: :controller do
  describe "POST #create" do
    let(:valid_attributes) { { name: 'John Doe', email: 'john@example.com', phone: '1234567890', message: 'Hello' } }

    before do
      # Mock the ApplicationMailer to prevent actual emails from being sent
      allow(ApplicationMailer).to receive_message_chain(:send_contact_email, :deliver_now)
    end

    it "sends an email with the contact message" do
      post :create, params: { contact: valid_attributes }
      expect(ApplicationMailer).to have_received(:send_contact_email).with(hash_including(valid_attributes))
    end

    it "returns a success message" do
      post :create, params: { contact: valid_attributes }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({'message' => 'Your contact message has been sent.'})
    end
  end
end
