# app/controllers/api/v1/contacts_controller.rb
# Controller for managing contact inquiries via API endpoints.
# This controller handles the creation and submission of contact inquiries via email.

class Api::V1::ContactsController < ActionController::API  # Corrected base class
  # POST /api/v1/contacts
  # Receives form data from the contact form, sends an email, and responds with a confirmation message.
  def create
    contact_params = params.require(:contact).permit(:name, :email, :phone, :message)
    
    ApplicationMailer.send_contact_email(contact_params).deliver_now
    
    render json: { message: 'Your contact message has been sent.' }, status: :ok
  end
end
