class UpdateForeignKeyConstraintsForYoungPersonManagements < ActiveRecord::Migration[7.0]
  def change

    remove_foreign_key :young_person_managements, column: :supporter_id, if_exists: true
    remove_foreign_key :young_person_managements, column: :young_person_id, if_exists: true


    add_foreign_key :young_person_managements, :supporters, column: :supporter_id, primary_key: :user_id
    add_foreign_key :young_person_managements, :young_people, column: :young_person_id, primary_key: :user_id
  end
end
