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

# The Bubble class represents groups or categories (termed 'bubbles') within the system.
# Each bubble is defined by a name and content and is held or owned by a 'YoungPerson'.
class Bubble < ApplicationRecord
    # Associations

    # Each bubble is associated with a 'YoungPerson', referred to as the holder.
    # 'holder_id' is used as the foreign key to establish this relationship.
    belongs_to :holder, class_name: "YoungPerson", foreign_key: "holder_id"

    # Manages invitations sent to potential members to join this bubble.
    # has_and_belongs_to_many :bubble_invites

    # Establishes a many-to-many relationship between bubbles and members through bubble invites.
    # This setup allows tracking of all members who have received invites to the bubble.
    # has_many :members, through: :bubble_invites, source: :user

    # Defines a many-to-many relationship with bubble members directly through a join table.
    # This relationship is primarily for handling direct membership without additional invite steps.
    has_and_belongs_to_many :members, class_name: "BubbleInvite",
      association_foreign_key: "member_id", join_table: "bubble_members_bubbles"

    # Manages the relationship with answers that are categorized under this bubble.
    # If a bubble is deleted, associated answers_bubbles entries are also destroyed.
    has_many :answers_bubbles, dependent: :destroy
    has_many :answers, through: :answers_bubbles

    # Validations

    # Ensures that each bubble has a name and content before it can be saved to the database.
    validates :name, presence: true
    validates :content, presence: true
  end
