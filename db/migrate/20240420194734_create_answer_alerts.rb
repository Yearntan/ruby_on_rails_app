class CreateAnswerAlerts < ActiveRecord::Migration[7.0]
  def change
    create_table :answer_alerts, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.uuid :answer_id, null: false  # Foreign key to the answers table
      t.text :commit  # Additional information about the alert

      t.timestamps
    end

    add_index :answer_alerts, :answer_id
    add_foreign_key :answer_alerts, :answers, column: :answer_id
  end
end
