class DropBubbles < ActiveRecord::Migration[7.0]
  def change
    drop_table :bubbles
  end
end
