# spec/features/login_spec.rb
require 'rails_helper'

RSpec.feature "UserLogins", type: :feature do
  let!(:user) { FactoryBot.create(:user, email: "user@example.com", password: "Password123", password_confirmation: "Password123") }

  scenario "User logs in with valid credentials" do
    visit login_path

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    expect(page).to have_content("You have been logged in, user id is: #{user.id}")
    expect(page).to have_current_path(user_path(user))
  end

  scenario "User logs in with invalid credentials" do
    visit login_path

    fill_in "Email", with: user.email
    fill_in "Password", with: "wrongpassword"
    click_button "Log in"

    expect(page).to have_content("Invalid email/password combination")
    expect(page).to have_current_path(login_path)
  end

  scenario "User logs out successfully" do
    # Log in first
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    # Log out
    click_link "Logout"  # Adjust this according to your actual logout link or button

    expect(page).to have_content("You have been logged out")
    expect(page).to have_current_path(root_path)
  end
end
