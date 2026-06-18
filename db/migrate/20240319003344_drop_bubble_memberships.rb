class DropBubbleMemberships < ActiveRecord::Migration[7.0]
  def change
    drop_table :bubble_memberships
  end
end
