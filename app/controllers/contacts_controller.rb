# app/controllers/contacts_controller.rb
# Manages contact forms within the application.
# This controller handles the creation and submission of contact inquiries via email.

class ContactsController < ApplicationController
    # GET /contacts/new
    # Renders a new contact form.
    def new
    end
  
    # POST /contacts
    # Receives form data from the contact form, sends an email, and redirects the user.
    def create
      # Strong parameters are used to prevent mass assignment vulnerabilities by
      # whitelisting only the necessary fields from the form.
      contact_params = params.require(:contact).permit(:name, :email, :phone, :message)
      
      # Calls the ApplicationMailer to send an email with the contact information.
      # deliver_now is used to send the email immediately.
      ApplicationMailer.send_contact_email(contact_params).deliver_now
      
      # After the email is sent, the user is redirected to a specified path (probably the homepage or contact page),
      # with a flash notice indicating that the message has been successfully sent.
      redirect_to contacts_url, notice: 'Your contact message has been sent.'
    end
  end
  