class RenameEmotionalSupportToEmotionalSupports < ActiveRecord::Migration[7.0]
  def change
    rename_table :emotional_support, :emotional_supports
  end
end
