class ChangeHolderIdReferenceInBubbles < ActiveRecord::Migration[7.0]
  def change
    remove_column :bubbles, :holder_id
    # remove_reference :bubbles, :holder_id, foreign_key: true, index: true
    change_table :bubbles do |t|
      t.references :holder, null: false, foreign_key: { to_table: :young_people }, default: 1
    end
  end
end
