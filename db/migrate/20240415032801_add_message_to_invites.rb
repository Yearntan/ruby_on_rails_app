class AddMessageToInvites < ActiveRecord::Migration[7.0]
    def change
      add_column :invites, :message, :text
    end
end