require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  render_views  # Optional: if you want to also check that views render without error

  # Test the about action
  describe "GET #about" do
    it "returns a successful response" do
      get :about
      expect(response).to be_successful  # This checks that the response was a success
    end
  end

  # Test the privacy action
  describe "GET #privacy" do
    it "returns a successful response" do
      get :privacy
      expect(response).to be_successful  # This checks that the response was a success
    end
  end

  # Test the cookies action
  describe "GET #cookies" do
    it "returns a successful response" do
      get :cookies
      expect(response).to be_successful  # This checks that the response was a success
    end
  end

  # Test the contact action
  describe "GET #contact" do
    it "returns a successful response" do
      get :contact
      expect(response).to be_successful  # This checks that the response was a success
    end
  end

  # Test the newuser action
  describe "GET #newuser" do
    it "returns a successful response" do
      get :newuser
      expect(response).to be_successful  # This checks that the response was a success
    end
  end
end
