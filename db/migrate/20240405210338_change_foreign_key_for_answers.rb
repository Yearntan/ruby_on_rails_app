class ChangeForeignKeyForAnswers < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :answers, column: :patient_id
    remove_index :answers, :patient_id
    rename_column :answers, :patient_id, :old_young_person_id
    add_column :answers, :young_person_id, :bigint


    remove_column :answers, :old_young_person_id
    add_index :answers, :young_person_id
    add_foreign_key :answers, :young_people, column: :young_person_id
  end
end