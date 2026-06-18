class CreateEmotionalSupportRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :emotional_support_requests, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
