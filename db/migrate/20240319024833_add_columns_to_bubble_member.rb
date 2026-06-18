class AddColumnsToBubbleMember < ActiveRecord::Migration[7.0]
  def change
    add_column :bubble_members, :name, :string
    add_column :bubble_members, :email, :string
  end
end
