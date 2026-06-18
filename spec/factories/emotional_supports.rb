# == Schema Information
#
# Table name: emotional_supports
#
#  id         :uuid             not null, primary key
#  content    :text
#  status     :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_emotional_supports_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => young_people.user_id)
#
FactoryBot.define do
  factory :emotional_support do
    content { "Need emotional support" }
    status { false }

    association :user
  end
end
