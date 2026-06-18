require 'rails_helper'

RSpec.describe Api::V1::ApplicationController, type: :controller do
  # Creating a dummy controller to test ApplicationController
  controller do
    def index
      render plain: "OK"
    end
  end

  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "CSRF protection" do
    it "raises an exception for CSRF attacks" do
      expect {
        post :index, params: {}, as: :json
      }.to raise_error(ActionController::InvalidAuthenticityToken)
    end
  end

  describe "Caching policies" do
    it "sets headers to disable caching" do
      get :index
      expect(response.headers['Cache-Control']).to eq('no-cache, no-store, must-revalidate, private, proxy-revalidate')
      expect(response.headers['Pragma']).to eq('no-cache')
      expect(response.headers['Expires']).to eq('0')
    end
  end

  describe "Authentication" do
    context "when user is not authenticated" do
      before do
        sign_out user
      end

      it "redirects to sign-in page" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "Parameter sanitization" do
    it "permits the correct parameters on sign-up" do
      # This assumes devise_parameter_sanitizer is accessible or mockable in this context
      parameters = [:name, :pronouns, :email, :password, :password_confirmation, :token]
      parameters.each do |param|
        expect(devise_parameter_sanitizer.for(:sign_up)).to include(param)
      end
    end
  end

  describe "Navigation after sign-in" do
    it "redirects young_person to the correct path" do
      allow(controller).to receive(:current_user).and_return(user)
      expect(controller.after_sign_in_path_for(user)).to eq(questions_path)
    end
  end
end
