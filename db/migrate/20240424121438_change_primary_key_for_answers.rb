class ChangePrimaryKeyForAnswers < ActiveRecord::Migration[7.0]
  def change

    add_index :answers, [:question_id, :user_id], unique: true unless index_exists?(:answers, [:question_id, :user_id], unique: true)
  end
end
