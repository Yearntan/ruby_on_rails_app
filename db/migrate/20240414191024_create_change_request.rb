class CreateChangeRequest < ActiveRecord::Migration[7.0]
  def change
    create_table :change_request, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.uuid :question_id, null: false
      t.boolean :status, default: false
      t.timestamps
    end

    add_foreign_key :change_request, :questions, column: :question_id
    add_index :change_request, :question_id
  end
end
