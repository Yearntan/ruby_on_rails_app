class AddSensitivityToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :sensitivity, :boolean
  end
end
