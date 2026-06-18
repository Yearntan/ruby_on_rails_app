class CreateTableBubbleMembership < ActiveRecord::Migration[7.0]
  def change
    create_table :bubble_memberships do |t|
      t.belongs_to :bubble
      t.belongs_to :user
      t.timestamps
    end
  end
end
