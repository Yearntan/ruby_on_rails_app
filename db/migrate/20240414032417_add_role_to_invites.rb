class AddRoleToInvites < ActiveRecord::Migration[7.0]
    def change
      add_column :invites, :role, :string
    end
end