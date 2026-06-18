class RenameInviteCodeToTokenInUsers < ActiveRecord::Migration[7.0]
    def change
      rename_column :users, :invite_code, :token
    end
end