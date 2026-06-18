class RecreateBubbles < ActiveRecord::Migration[7.0]
  def change
    create_table :bubbles, id: :uuid do |t|
      t.string :name
      t.belongs_to :holder, index: true, null: false
      t.timestamps
    end
  end
end
