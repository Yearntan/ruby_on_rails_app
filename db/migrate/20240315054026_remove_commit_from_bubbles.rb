class RemoveCommitFromBubbles < ActiveRecord::Migration[7.0]
  def change
    remove_column :bubbles, :commit, :text
  end
end
