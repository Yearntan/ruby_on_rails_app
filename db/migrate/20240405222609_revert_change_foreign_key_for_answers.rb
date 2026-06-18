class RevertChangeForeignKeyForAnswers < ActiveRecord::Migration[7.0]
  def change
    remove_reference :answers, :young_person, index: true, foreign_key: true
    add_reference :answers, :user, index: true, foreign_key: true, type: :uuid
  end
end