# == Schema Information
#
# Table name: questions
#
#  id               :uuid             not null, primary key
#  active           :boolean          default(TRUE)
#  change           :boolean          default(FALSE)
#  content          :text
#  sensitivity      :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  ques_category_id :bigint
#
# Foreign Keys
#
#  fk_rails_...  (ques_category_id => ques_categories.id)
#
FactoryBot.define do
  factory :question do
    # Set default content for the question
    content { "What is your favourite place?" }
    # Set default sensitivity attribute to false
    sensitivity { false }
    # Set default active attribute to true
    active { true }
    # Set default change attribute to false
    change { false }
    # Create an association between the question and a QuesCategory object
    association :ques_category
  end
end

