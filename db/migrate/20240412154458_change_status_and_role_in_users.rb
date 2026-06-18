class ChangeStatusAndRoleInUsers < ActiveRecord::Migration[7.0]
  def up
    change_column :users, :status, :integer, using: 'status::integer'
    change_column :users, :role, :integer, using: 'role::integer'
  end

  def down
    change_column :users, :status, :string
    change_column :users, :role, :string
  end
end
