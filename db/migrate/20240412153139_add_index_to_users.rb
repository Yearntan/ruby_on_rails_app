class AddIndexToUsers < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :id, unique: true, name: 'index_users_on_id' unless index_exists?(:users, :id)
  end
end
