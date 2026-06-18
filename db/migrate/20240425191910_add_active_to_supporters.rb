class AddActiveToSupporters < ActiveRecord::Migration[7.0]
  def change
    add_column :supporters, :active, :boolean, default: true
  end
end
