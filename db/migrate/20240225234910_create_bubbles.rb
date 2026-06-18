class CreateBubbles < ActiveRecord::Migration[6.0]
  def change
    create_table :bubbles, id: :uuid do |t|
      t.string :name
      t.text :commit
      t.references :holder, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.references :member, null: false, foreign_key: { to_table: :users }, type: :uuid

      t.timestamps
    end

    add_index :bubbles, [:id, :member_id], unique: true
  end
end