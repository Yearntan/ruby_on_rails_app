class CreateFutureMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :future_messages, id: :uuid do |t|
      t.text :content
      t.datetime :published_at
      t.references :user, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.timestamps
    end
  end
end
