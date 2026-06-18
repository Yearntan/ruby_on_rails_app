class AddContentToBubbles < ActiveRecord::Migration[7.0]
  def change
    add_column :bubbles, :content, :text
  end
end
