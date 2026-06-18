class EnsureUniqueIndexOnSupportersAndYoungPeople < ActiveRecord::Migration[7.0]
  def up

    remove_index :supporters, :user_id, if_exists: true
    remove_index :young_people, :user_id, if_exists: true

 
    add_index :supporters, :user_id, unique: true
    add_index :young_people, :user_id, unique: true
  end

  def down
    remove_index :supporters, :user_id
    remove_index :young_people, :user_id
    

    add_index :supporters, :user_id
    add_index :young_people, :user_id
  end
end
