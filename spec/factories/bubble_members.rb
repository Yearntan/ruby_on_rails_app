# == Schema Information
#
# Table name: bubble_members
#
#  id         :bigint           not null, primary key
#  email      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_bubble_members_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :bubble_member do
    # Create an association between the bubble member and a User object
    association :user
    # Set default value of name attribute to nil
    name { nil }
    # Set default value of email attribute to nil
    email { nil }
  end
end

