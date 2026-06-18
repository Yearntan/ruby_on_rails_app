class CreateQuesCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :ques_categories do |t|
      t.string :name
      t.boolean :active

      t.timestamps
    end
  end
end
