class RenamePatientManagementsToYoungPersonManagements < ActiveRecord::Migration[7.0]
  def change

    remove_index :patient_managements, name: 'index_patient_managements_on_supporter_id_and_patient_id'
    remove_index :patient_managements, name: 'index_patient_managements_on_patient_id'
    remove_index :patient_managements, name: 'index_patient_managements_on_supporter_id'
    

    rename_table :patient_managements, :young_person_managements
    

    rename_column :young_person_managements, :patient_id, :young_person_id

    add_index :young_person_managements, [:supporter_id, :young_person_id], unique: true, name: 'index_yp_managements_on_supporter_and_yp_id'
    add_index :young_person_managements, :young_person_id, name: 'index_yp_managements_on_yp_id'
    add_index :young_person_managements, :supporter_id, name: 'index_yp_managements_on_supporter_id'
  end
end
