class AddUserIdToInvites < ActiveRecord::Migration[7.0]
    def change
      add_column :invites, :user_id, :uuid
    end
end