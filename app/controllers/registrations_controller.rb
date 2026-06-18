# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters
  
    def create
      super do |user|
        if user.persisted?
          invite = Invite.find_by(token: params[:user][:token])
  
          if invite && invite.expiration_date > Time.now && !invite.used
            user.role = invite.role
            invite.update!(used: true)
            user.save!
  
            case user.role
            when 'young_person'
              YoungPerson.create!(user: user, passed_away: false)
            when 'supporter'
              Supporter.create!(user: user)
            end
  
            flash[:notice] = "User was successfully created with role #{invite.role}."
          else
            user.errors.add(:token, 'is invalid or has expired')
            flash[:alert] = "Invalid or expired token."
          end
        end
      end
    end
  
    protected
  
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :pronouns, :token])
    end
end