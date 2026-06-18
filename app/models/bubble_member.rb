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

# The BubbleMember class represents individuals who are members of various 'bubbles' or groups within the system.
# Each member has a unique identity linked to a user account and can participate in multiple bubbles.
class BubbleMember < ApplicationRecord
  # Associations
  
  # Associates the bubble member with a user entity, ensuring each bubble member has a corresponding user.
  belongs_to :user

  # Manages the collection of invitations that have been sent to the bubble member to join different bubbles.
  # Invitations are managed through the BubbleInvite class.
  has_many :invites, class_name: 'BubbleInvite', foreign_key: 'bubble_member_id'

  # Establishes a many-to-many relationship with bubbles. This member can be part of multiple bubbles.
  # The relationship is managed through the 'bubble_members_bubbles' join table.
  has_and_belongs_to_many :bubbles, foreign_key: "member_id", join_table: "bubble_members_bubbles"
end
