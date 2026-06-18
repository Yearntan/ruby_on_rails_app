class RenameEmotionalSupportRequestsToEmotionalSupport < ActiveRecord::Migration[7.0]
  def change
    rename_table :emotional_support_requests, :emotional_support
  end
end