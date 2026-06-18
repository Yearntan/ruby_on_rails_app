# spec/controllers/contacts_controller_spec.rb
require 'rails_helper'

RSpec.describe ContactsController, type: :controller do
  describe "GET #new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    let(:valid_attributes) { { name: 'John Doe', email: 'john@example.com', phone: '123-456-7890', message: 'Hello, this is a test message.' } }
    let(:invalid_attributes) { { name: '', email: 'invalid_email', phone: '', message: '' } }

    context "with valid params" do
      it "sends a contact email" do
        expect {
          post :create, params: { contact: valid_attributes }
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it "redirects to the contacts url with a notice" do
        post :create, params: { contact: valid_attributes }
        expect(response).to redirect_to(contacts_url)
        expect(flash[:notice]).to eq('Your contact message has been sent.')
      end
    end

    context "with invalid params" do
      it "does not send a contact email" do
        expect {
          post :create, params: { contact: invalid_attributes }
        }.not_to change { ActionMailer::Base.deliveries.count }
      end

      it "renders the new template again" do
        post :create, params: { contact: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end
end
