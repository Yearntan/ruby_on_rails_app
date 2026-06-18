class AddContentToChangeRequestTable < ActiveRecord::Migration[7.0]
  def change
    add_column :change_request, :content, :text
  end
end
