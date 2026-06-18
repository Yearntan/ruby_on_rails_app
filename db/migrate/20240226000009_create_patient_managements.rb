class CreatePatientManagements < ActiveRecord::Migration[6.0]
  def change
    create_table :patient_managements, id: false do |t|
      t.references :supporter, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.references :patient, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.text :commit
      t.integer :status, default: 0

      t.timestamps
    end

    add_index :patient_managements, [:supporter_id, :patient_id], unique: true
  end
end