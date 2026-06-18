class RenamePronounsInUsers < ActiveRecord::Migration[6.0]
    def change
      rename_column :users, :Pronouns, :pronouns
    end
end