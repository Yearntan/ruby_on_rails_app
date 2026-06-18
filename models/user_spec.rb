# == Schema Information
#
# Table name: users
#
#  id                       :uuid             not null, primary key
#  bypass_invite_validation :boolean
#  current_sign_in_at       :datetime
#  current_sign_in_ip       :string
#  email                    :string
#  encrypted_password       :string           default(""), not null
#  last_sign_in_at          :datetime
#  last_sign_in_ip          :string
#  name                     :string
#  password                 :string
#  pronouns                 :string
#  remember_created_at      :datetime
#  reset_password_sent_at   :datetime
#  reset_password_token     :string
#  role                     :integer
#  sign_in_count            :integer          default(0), not null
#  status                   :integer
#  token                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_users_on_id                    (id) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
RSpec.describe User, type: :model do
  # Pending example - No tests are defined here yet
  pending "add some examples to (or delete) #{__FILE__}"

  # Describe login functionality
  describe 'Login' do
    # Test logging in with correct details
    specify 'I can log in as a user' do
      # Create a user for testing login functionality
      user = User.create(
        name: 'user', 
        email: 'user.email.address@sheffield.ac.uk', 
        password: 'Password123', 
        password_confirmation: 'Password123', 
        pronouns: 'She/Her', 
        status: 2, 
        role: :admin, 
        bypass_invite_validation: true
      )
      
      # Visit the login page
      visit '/users/sign_in'

      # Fill in email and password fields
      fill_in 'Email', with: 'user.email.address@sheffield.ac.uk'
      fill_in 'Password', with: 'Password123'

      # Click on the login button
      click_on 'Log in'

      # Expect to see success message
      expect(page).to have_content 'Signed in successfully.'
    end

    # Test logging in with incorrect details
    specify 'I cannot login with incorrect details' do
      # Visit the login page
      visit '/users/sign_in'

      # Fill in incorrect email and password fields
      fill_in 'Email', with: 'email@email.com'
      fill_in 'Password', with: 'Password'

      # Click on the login button
      click_on 'Log in'

      # Expect to see error message
      expect(page).to have_content 'Invalid Email or password.'
    end

    # Test logging in with blank fields
    specify 'I cannot leave any fields blank' do
      # Visit the login page
      visit '/users/sign_in'

      # Click on the login button without filling in any fields
      click_on 'Log in'

      # Expect to see error message
      expect(page).to have_content 'Invalid Email or password.'
    end
  end

  # Describe registration functionality
  describe 'Registration' do
    # Test user registration
    specify 'I can register for an account' do
      # Visit the registration page
      visit '/users/sign_up'

      # Fill in registration form
      fill_in 'Name', with: 'user'
      fill_in 'Email', with: 'newuser@sheffield.ac.uk'
      fill_in 'Pronouns', with: 'She/Her'
      fill_in 'Password', with: 'Password123'
      fill_in 'Password confirmation', with: 'Password123'

      # Click on the sign up button
      click_on 'Sign up'

      # Expect to be redirected to users page
      expect(current_path).to eq('/users')
    end

    # Test leaving name field blank during registration
    specify 'I cannot leave the name field blank' do
      # Visit the registration page
      visit '/users/sign_up'

      # Fill in registration form without a name
      fill_in 'Email', with: 'email@email.com'

      # Click on the sign up button
      click_on 'Sign up'

      # Expect to see error message
      expect(page).to have_content "Name can't be blank"
    end

    # Test leaving email field blank during registration
    specify 'I cannot leave the email field blank' do
      # Visit the registration page
      visit '/users/sign_up'

      # Fill in registration form without an email
      fill_in 'Password', with: 'Password123'
      fill_in 'Password confirmation', with: 'Password123'

      # Click on the sign up button
      click_on 'Sign up'

      # Expect to see error message
      expect(page).to have_content "Email can't be blank"
    end

    # Test leaving password field blank during registration
    specify 'I cannot leave the password field blank' do
      # Visit the registration page
      visit '/users/sign_up'

      # Fill in registration form without a password
      fill_in 'Email', with: 'email@email.com'

      # Click on the sign up button
      click_on 'Sign up'

      # Expect to see error message
      expect(page).to have_content "Password can't be blank"
    end

    # Test leaving the invite code field blank during registration
    specify 'I cannot leave the invite code field blank' do
      # Visit the registration page
      visit '/users/sign_up'

      # Fill in registration form without an invite code
      fill_in 'Email', with: 'email@email.com'

      # Click on the sign up button
      click_on 'Sign up'

      # Expect to see error message
      expect(page).to have_content "Token can't be blank"
    end

    # Test inputting the wrong invite code during registration
    specify 'I cannot input the wrong invite code' do
      # Visit the registration page
      visit '/users/sign_up'

      # Fill in registration form with an incorrect invite code
      fill_in 'Invite Code', with: 'abcdefg'

      # Click on the sign up button
      click_on 'Sign up'

      # Expect to see error message
      expect(page).to have_content "Token is invalid, expired, or has already been used"
    end

    # Test registering with a password confirmation that does not match the password
    specify 'I cannot register for an account if the password does not match the password confirmation' do
      # Visit the registration page
      visit '/users/sign_up'

      # Fill in registration form with mismatching passwords
      fill_in 'Email', with: 'email@email.com'
      fill_in 'Password', with: 'Password123'
      fill_in 'Password confirmation', with: 'Password'

      # Click on the sign up button
      click_on 'Sign up'

      # Expect to see error message
      expect(page).to have_content "Password confirmation doesn't match Password"
    end

    # Test registering with an email that is already in use
    specify 'I cannot register an account with an email that is already in use' do
      # Create a user with the provided email
      user = User.create(
        name: 'user', 
        email: 'user.email.address@sheffield.ac.uk', 
        password: 'Password123', 
        password_confirmation: 'Password123', 
        pronouns: 'She/Her', 
        status: 2, 
        role: :admin, 
        bypass_invite_validation: true
      )
      
      # Visit the registration page
      visit '/users/sign_up'

      # Fill in registration form with the same email
      fill_in 'Email', with: 'user.email.address@sheffield.ac.uk'

      # Click on the sign up button
      click_on 'Sign up'

      # Expect to see error message
      expect(page).to have_content "Email has already been taken"
    end
  end

  # Describe forgotten password functionality
  describe 'Forgotten Password' do
    # Test leaving email field blank when requesting password reset
    specify 'I cannot leave the email field blank' do
      # Visit the password reset page
      visit '/users/password/new'

      # Click on the reset password button without filling in email
      click_on 'Send me reset password instructions'

      # Expect to see error message
      expect(page).to have_content "Email can't be blank"
    end

    # Test requesting to reset password with valid email
    specify 'I can request to reset my password' do
      # Create a user for testing password reset functionality
      user = User.create(
        name: 'user', 
        email: 'user.email.address@sheffield.ac.uk', 
        password: 'Password123', 
        password_confirmation: 'Password123', 
        pronouns: 'She/Her', 
        status: 2, 
        role: :admin, 
        bypass_invite_validation: true
      )

      # Visit the password reset page
      visit '/users/password/new'

      # Fill in email for password reset
      fill_in 'Email', with: 'user.email.address@sheffield.ac.uk'

      # Click on the reset password button
      click_on 'Send me reset password instructions'

      # Expect to see success message
      expect(page).to have_content "You will receive an email with instructions on how to reset your password in a few minutes."
    end

    # Test requesting to reset password with invalid email
    specify 'I cannot request to change my password using an email that does not have an account connected to it' do
      # Visit the password reset page
      visit '/users/password/new'

      # Fill in non-existent email for password reset
      fill_in 'Email', with: 'email@email.com'

      # Click on the reset password button
      click_on 'Send me reset password instructions'

      # Expect to see error message
      expect(page).to have_content "Email not found"
    end
  end
end
