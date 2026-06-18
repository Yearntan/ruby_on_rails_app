# == Schema Information
#
# Table name: ques_categories
#
#  id         :bigint           not null, primary key
#  active     :boolean
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :ques_category do
    # Set default name for the question category
    name { "My bucket list" } 
    # Set default value of active attribute to true
    active { true }
  end
end

