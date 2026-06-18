# == Schema Information
#
# Table name: bubbles
#
#  id         :uuid             not null, primary key
#  content    :text
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  holder_id  :bigint           not null
#
# Indexes
#
#  index_bubbles_on_holder_id  (holder_id)
#

# Define a factory for Bubble model
FactoryBot.define do
  factory :bubble do
    name { "bubble" } # Set a default name for the bubble
    content { "Some content for bubble" } # Set a default content for the bubble
    association :holder, factory: :young_person # Associate the bubble with a young_person
  end

  # Define a factory for FamilyBubble, which is a type of Bubble
  factory :family_bubble, class: "Bubble" do
    name { "family" } # Set a default name for the family bubble
    content { "Some content for family bubble" } # Set a default content for the family bubble
    association :holder, factory: :young_person # Associate the family bubble with a young_person
  end

  # Define a factory for FriendsBubble, which is a type of Bubble
  factory :friends_bubble, class: "Bubble" do
    name { "friends" } # Set a default name for the friends bubble
    content { "Some content for friends bubble" } # Set a default content for the friends bubble
    association :holder, factory: :young_person # Associate the friends bubble with a young_person
  end
end