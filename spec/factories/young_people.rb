# == Schema Information
#
# Table name: young_people
#
#  id          :bigint           not null, primary key
#  passed_away :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :uuid             not null
#
# Indexes
#
#  index_young_people_on_user_id  (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :young_person do
    # association :bubbles
    user
    passed_away { false }

  end
end
