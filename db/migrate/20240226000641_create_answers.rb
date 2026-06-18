class CreateAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :answers, id: :uuid do |t|
      t.references :question, null: false, foreign_key: true, type: :uuid
      t.references :patient, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.text :content

      t.timestamps
    end

    add_index :answers, [:question_id, :patient_id], unique: true
  end
end