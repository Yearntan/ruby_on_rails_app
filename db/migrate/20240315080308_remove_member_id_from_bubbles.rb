class RemoveMemberIdFromBubbles < ActiveRecord::Migration[7.0]
  def change
    remove_column :bubbles, :member_id
  end
end
