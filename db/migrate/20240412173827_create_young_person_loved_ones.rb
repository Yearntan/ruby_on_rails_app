class CreateYoungPersonLovedOnes < ActiveRecord::Migration[7.0]
  def change
    create_table :young_person_loved_ones do |t|
      t.uuid :young_person_id
      t.uuid :loved_one_id

      t.timestamps
    end
  end
end
