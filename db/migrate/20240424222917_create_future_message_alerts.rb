class CreateFutureMessageAlerts < ActiveRecord::Migration[7.0]
  def change
    create_table :future_message_alerts do |t|
      t.references :future_message, null: false, foreign_key: true, type: :uuid
      t.boolean :active, default: true
      t.text :commit

      t.timestamps
    end
  end
end
