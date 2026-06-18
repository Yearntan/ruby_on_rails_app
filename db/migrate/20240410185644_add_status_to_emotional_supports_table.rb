class AddStatusToEmotionalSupportsTable < ActiveRecord::Migration[7.0]
  def change
    add_column :emotional_supports, :status, :boolean, default: false
  end
end