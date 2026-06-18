class ChangeMemberAssociationInBubbleMemberBubbles < ActiveRecord::Migration[7.0]
  def change
    remove_reference :bubble_members_bubbles, :member
    add_reference :bubble_members_bubbles, :member, null: false, foreign_key: { to_table: :bubble_invites }
  end
end
