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

# The YoungPerson class represents individuals who are considered "young people" within the system.
# It maintains information about their status, associations, and activities within the application.
class YoungPerson < ApplicationRecord
  # Associations

  # Each YoungPerson record is associated with exactly one user, defining their identity within the system.
  # This association is based on the user_id attribute and links to the id primary key in the users table.
  belongs_to :user, foreign_key: 'user_id', primary_key: 'id'

  # Young people can hold multiple bubbles, indicating their participation or membership in various social groups.
  has_many :bubbles, foreign_key: "holder"

  # Young people can receive invites to join bubbles, which are managed through the BubbleInvite class.
  has_many :invites, class_name: "BubbleInvite"

  # Young people can be members of multiple bubbles, linked through the BubbleMember association.
  has_many :bubble_members, through: :bubbles, source: :members

  # Young people can receive emotional support from other users, tracked through the EmotionalSupport class.
  has_many :emotional_supports, foreign_key: :user_id, primary_key: :user_id

  # Young people can provide answers to various questions in the system, accessed through the Answer class.
  has_many :answers, through: :user

  # Young people can send future messages to themselves, stored in the FutureMessage class.
  has_many :future_messages, foreign_key: 'user_id', primary_key: 'user_id'
end
