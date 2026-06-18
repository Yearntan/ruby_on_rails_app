# == Schema Information
#
# Table name: bubble_invites
#
#  id               :bigint           not null, primary key
#  email            :string           not null
#  name             :string           not null
#  status           :integer          default("pending")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  bubble_member_id :bigint
#  young_person_id  :bigint           not null
#
# Indexes
#
#  index_bubble_invites_on_bubble_member_id  (bubble_member_id)
#  index_bubble_invites_on_young_person_id   (young_person_id)
#
# Foreign Keys
#
#  fk_rails_...  (bubble_member_id => bubble_members.id)
#  fk_rails_...  (young_person_id => young_people.id)
#

# The BubbleInvite class models an invitation sent to potential members to join specific 'bubbles' (groups or categories).
# It tracks basic information such as the invitee's email and name, and maintains links to both young people and
# bubble members.

class BubbleInvite < ApplicationRecord
  # Associations
  
  # Each invite is sent to a specific young person, identified by young_person_id.
  belongs_to :young_person
  
  # Each invite may or may not be linked to an existing bubble member, allowing flexibility in invite management.
  belongs_to :bubble_member, optional: true
  has_and_belongs_to_many :bubbles, foreign_key: "member_id", join_table: "bubble_members_bubbles"

  enum status: { pending: 0, accepted: 1, rejected: 2 }

  validates :email, :name, presence: true
end

