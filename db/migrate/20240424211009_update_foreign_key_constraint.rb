class UpdateForeignKeyConstraint < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :answer_alerts, :answers
    add_foreign_key :answer_alerts, :answers, on_delete: :cascade
  end
end