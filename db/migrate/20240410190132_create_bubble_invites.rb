class CreateBubbleInvites < ActiveRecord::Migration[7.0]
  def change
    create_table :bubble_invites do |t|
      t.belongs_to :young_person, index: true, null: false, foreign_key: true
      t.references :bubble_member, null: true, foreign_key: true
      t.string :email, null: false
      t.string :name, null: false
      t.timestamps
    end
  end
end
