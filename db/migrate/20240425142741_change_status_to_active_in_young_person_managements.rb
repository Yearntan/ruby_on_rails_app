class ChangeStatusToActiveInYoungPersonManagements < ActiveRecord::Migration[7.0]
  def change
    rename_column :young_person_managements, :status, :active
    change_column_default :young_person_managements, :active, true
  end
end