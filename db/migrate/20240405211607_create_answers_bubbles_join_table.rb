class CreateAnswersBubblesJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_table :answers_bubbles, id: false do |t|
      t.uuid :answer_id, null: false
      t.uuid :bubble_id, null: false
    end

    add_index :answers_bubbles, [:answer_id, :bubble_id], unique: true

    add_foreign_key :answers_bubbles, :answers, column: :answer_id
    add_foreign_key :answers_bubbles, :bubbles, column: :bubble_id
  end
end
