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

# Define a factory for User model
FactoryBot.define do
  factory :user, class: User do
    sequence(:name) { |n| "user#{n}" } # Generate a unique name for each user
    email { Faker::Internet.email } # Generate a random email using Faker gem
    password { 'Password123' } # Set a default password
    password_confirmation { 'Password123' } # Confirm the password
    pronouns { "She/Her" } # Set a default pronoun
    bypass_invite_validation {true} # Bypass the invite validation
    status { 1 } # Set a default status
    role { :admin } # Set a default role

    # Define a trait for young_person role
    trait :young_person do
      role { :young_person }
      after(:create) do |user|
        create(:young_person, user: user)
      end
    end

    # Define a trait for supporter role
    trait :supporter do
      role { :supporter }
    end

    # Define a trait for loved_one role
    trait :loved_one do
      role { :loved_one }
      sequence(:name) { |n| "loved_one#{n}" } # Generate a unique name for each loved_one
      sequence(:email) { |n| "loved_one#{n}@sheffield.ac.uk" } # Generate a unique email for each loved_one
    end
    
    # Define a trait for admin role
    trait :admin do
      name { "admin1" } # Set a default name
      email { 'admin.email.address@sheffield.ac.uk' } # Set a default email
      password { 'Password123' } # Set a default password
      password_confirmation { 'Password123' } # Confirm the password
      pronouns { "She/Her" } # Set a default pronoun
      status { 1 } # Set a default status
      role { :admin } # Set a default role
    end
  end
end