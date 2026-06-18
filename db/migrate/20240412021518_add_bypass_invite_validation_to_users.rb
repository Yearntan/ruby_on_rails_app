class AddBypassInviteValidationToUsers < ActiveRecord::Migration[7.0]
    def change
      add_column :users, :bypass_invite_validation, :boolean
    end
end