class AddForeignKeyToQuestions < ActiveRecord::Migration[7.0]
  def change

    unless column_exists?(:questions, :ques_category_id)
      add_column :questions, :ques_category_id, :bigint
    end

    add_foreign_key :questions, :ques_categories, column: :ques_category_id
  end
end
