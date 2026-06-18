class CreateYoungPeople < ActiveRecord::Migration[7.0]
  def change
    create_table :young_people do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
