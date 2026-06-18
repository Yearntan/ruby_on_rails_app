# == Schema Information
#
# Table name: answer_alerts
#
#  id         :uuid             not null, primary key
#  active     :boolean          default(TRUE)
#  commit     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  answer_id  :uuid             not null
#
# Indexes
#
#  index_answer_alerts_on_answer_id  (answer_id)
#
# Foreign Keys
#
#  fk_rails_...  (answer_id => answers.id) ON DELETE => cascade
#
FactoryBot.define do
  factory :answer_alert do
    # Ensure there's a corresponding factory for `Answer`
    association :answer  
    # Set default commit message or details about the alert
    commit { "Some commit message or details about the alert." }
    # Set default value of active attribute to true (as per your schema default)
    active { true }

    # Define traits for active and inactive alerts
    trait :active do
      active { true }
    end

    trait :inactive do
      active { false }
    end
  end
end