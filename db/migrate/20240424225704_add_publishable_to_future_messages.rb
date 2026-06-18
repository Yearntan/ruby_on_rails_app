class AddPublishableToFutureMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :future_messages, :publishable, :boolean, default: false
  end
end