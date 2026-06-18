# db/migrate/[timestamp]_drop_young_person_loved_ones.rb
class DropYoungPersonLovedOnes < ActiveRecord::Migration[7.0]
  def up
    drop_table :young_person_loved_ones
  end

  def down
    create_table :young_person_loved_ones do |t|
      t.uuid :young_person_id
      t.uuid :loved_one_id
      t.timestamps
    end
  end
end
