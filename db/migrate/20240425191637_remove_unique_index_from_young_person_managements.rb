class RemoveUniqueIndexFromYoungPersonManagements < ActiveRecord::Migration[6.1]
  def change
    remove_index :young_person_managements, name: "index_yp_managements_on_supporter_and_yp_id"
    add_index :young_person_managements, [:id], name: "index_yp_managements_on_id"
  end
end
