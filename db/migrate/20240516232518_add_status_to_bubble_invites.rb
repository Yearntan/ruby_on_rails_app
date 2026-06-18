class AddStatusToBubbleInvites < ActiveRecord::Migration[7.0]
  def change
    add_column :bubble_invites, :status, :integer, default: 0
  end
end
