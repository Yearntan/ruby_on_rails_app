class ChangeFutureMessagesForeignKey < ActiveRecord::Migration[7.0]
  def change
    change_table :future_messages do |t|
      t.remove_foreign_key :users
      t.foreign_key :young_people, column: :user_id, primary_key: :user_id
    end
  end
end