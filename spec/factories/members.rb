# spec/factories/members.rb
FactoryBot.define do
    factory :member do
      name { "John Doe" }
      email { "john@example.com" }
      # add other necessary attributes and associations
    end
  end
  