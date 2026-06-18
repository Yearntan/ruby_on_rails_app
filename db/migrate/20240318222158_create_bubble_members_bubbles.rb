class CreateBubbleMembersBubbles < ActiveRecord::Migration[7.0]
  def change
    create_table :bubble_members_bubbles do |t|
      t.belongs_to :bubble, null: false, foreign_key: true, type: :uuid
      t.belongs_to :member, null: false, foreign_key: { to_table: :bubble_members }

      t.timestamps
    end
  end
end
