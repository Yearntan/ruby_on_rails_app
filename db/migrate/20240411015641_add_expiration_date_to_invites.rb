class AddExpirationDateToInvites < ActiveRecord::Migration[7.0]
    def change
      add_column :invites, :expiration_date, :datetime
    end
end