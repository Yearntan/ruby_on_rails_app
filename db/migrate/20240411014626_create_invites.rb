class CreateInvites < ActiveRecord::Migration[7.0]
    def change
      create_table :invites do |t|
        t.string :code
        t.string :email
        t.boolean :used
  
        t.timestamps
      end
    end
end