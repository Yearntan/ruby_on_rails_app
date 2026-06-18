require 'rails_helper'

RSpec.describe Api::V1::StaticPagesController, type: :controller do
  describe "GET #about" do
    it "returns the about page content" do
      get :about
      expect(response).to have_http_status(:ok)
      expect(json_response['message']).to eq('This is the About page of the application.')
    end
  end

  describe "GET #privacy" do
    it "returns the privacy policy content" do
      get :privacy
      expect(response).to have_http_status(:ok)
      expect(json_response['message']).to eq('This is the Privacy page of the application.')
    end
  end

  describe "GET #cookies" do
    it "returns the cookies policy content" do
      get :cookies
      expect(response).to have_http_status(:ok)
      expect(json_response['message']).to eq('This is the Cookies page of the application.')
    end
  end

  describe "GET #newuser" do
    it "returns the new user guide content" do
      get :newuser
      expect(response).to have_http_status(:ok)
      expect(json_response['message']).to eq('This is the New User page of the application.')
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end
