class AddTokenToInvites < ActiveRecord::Migration[7.0]
    def change
      add_column :invites, :token, :string
    end
end