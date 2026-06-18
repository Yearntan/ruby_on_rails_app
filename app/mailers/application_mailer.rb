class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@sheffield.ac.uk"
  layout "mailer"

  def send_contact_email(info)
    @info = info
    mail(to: 'team22@sheffield.ac.uk', subject: 'New Contact Message') do |format|
      format.text
    end
  end

  def send_invite_email(user, invitee_email, token, message)
    @user = user
    @message = message
    @token = token
    mail(to: invitee_email, subject: 'You are invited!')
  end
end