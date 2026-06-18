class AddIdToYoungPersonManagements < ActiveRecord::Migration[7.0]
  def change
    add_column :young_person_managements, :id, :uuid, default: "gen_random_uuid()", primary_key: true
    remove_index :young_person_managements, name: "index_yp_managements_on_supporter_and_yp_id"
    add_index :young_person_managements, [:supporter_id, :young_person_id], unique: true, name: "index_yp_managements_on_supporter_and_yp_id"
  end
end
