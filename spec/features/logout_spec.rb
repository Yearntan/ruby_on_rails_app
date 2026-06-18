# spec/features/logout_spec.rb
require 'rails_helper'

RSpec.feature "UserLogouts", type: :feature do
  let!(:user) { FactoryBot.create(:user, email: "user@example.com", password: "Password123", password_confirmation: "Password123") }

  before do
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
  end

  scenario "User logs out successfully" do
    click_link "Log out"  # Adjust this according to your actual logout link or button

    expect(page).to have_content("You have been logged out")
    expect(page).to have_current_path(root_path)
  end
end
