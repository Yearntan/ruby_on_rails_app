# spec/factories/supporter_managements.rb
FactoryBot.define do
    factory :supporter_management do
      supporter { create(:user, role: 'supporter') }
      young_person { create(:user, role: 'young_person') }
    end
  end
  