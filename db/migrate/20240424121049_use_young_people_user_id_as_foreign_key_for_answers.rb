class UseYoungPeopleUserIdAsForeignKeyForAnswers < ActiveRecord::Migration[7.0]
  def change

    remove_foreign_key :answers, :users if foreign_key_exists?(:answers, :users)
    remove_index :answers, :user_id if index_exists?(:answers, :user_id)
    
    add_foreign_key :answers, :young_people, column: :user_id, primary_key: :user_id

    add_index :answers, :user_id
  end
end
