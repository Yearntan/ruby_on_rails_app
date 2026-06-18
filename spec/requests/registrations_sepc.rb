require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "POST #create" do
    context "with valid invite token" do
      let(:invite) { create(:invite, role: 'young_person') }

      it "creates a new user with the specified role" do
        post :create, params: { user: { email: 'test@example.com', password: 'password', token: invite.token } }
        expect(User.last.role).to eq('young_person')
        expect(YoungPerson.count).to eq(1)
        expect(flash[:notice]).to eq("User was successfully created with role young_person.")
      end

      it "marks the invite as used" do
        post :create, params: { user: { email: 'test@example.com', password: 'password', token: invite.token } }
        expect(invite.reload.used).to be true
      end
    end

    context "with invalid invite token" do
      it "does not create a new user" do
        post :create, params: { user: { email: 'test@example.com', password: 'password', token: 'invalid_token' } }
        expect(User.count).to eq(0)
        expect(flash[:alert]).to eq("Invalid or expired token.")
      end
    end

    context "with expired invite token" do
      let(:invite) { create(:invite, role: 'young_person', expiration_date: 1.day.ago) }

      it "does not create a new user" do
        post :create, params: { user: { email: 'test@example.com', password: 'password', token: invite.token } }
        expect(User.count).to eq(0)
        expect(flash[:alert]).to eq("Invalid or expired token.")
      end
    end
  end

  describe "POST #create with supporter role" do
    let(:invite) { create(:invite, role: 'supporter') }

    it "creates a new user with the supporter role" do
      post :create, params: { user: { email: 'test@example.com', password: 'password', token: invite.token } }
      expect(User.last.role).to eq('supporter')
      expect(Supporter.count).to eq(1)
      expect(flash[:notice]).to eq("User was successfully created with role supporter.")
    end
  end

  describe "protected methods" do
    it "permits name, pronouns, and token parameters" do
      params = { user: { name: 'John Doe', pronouns: 'he/him', token: 'valid_token' } }
      should permit(:name, :pronouns, :token).for(:sign_up, params: params).on(:user)
    end
  end

  describe "before_action :configure_permitted_parameters" do
    it "calls the configure_permitted_parameters method" do
      expect(controller).to receive(:configure_permitted_parameters)
      post :create, params: { user: { email: 'test@example.com', password: 'password', token: 'valid_token' } }
    end
  end

  describe "protected method configure_permitted_parameters" do
    it "permits name, pronouns, and token parameters" do
      expect(controller).to receive(:devise_parameter_sanitizer).and_return(double(:sanitizer, permit: nil))
      controller.send(:configure_permitted_parameters)
      expect(controller).to have_received(:devise_parameter_sanitizer).with(:sign_up, keys: [:name, :pronouns, :token])
    end
  end
end