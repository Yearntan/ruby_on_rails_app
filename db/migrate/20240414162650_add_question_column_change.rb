class AddQuestionColumnChange < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :change, :boolean, default: false
  end
end
