class ChangeForeignKeyForEmotionalSupports < ActiveRecord::Migration[7.0]
  def change

    unless column_for(:emotional_supports, :user_id).sql_type == 'uuid'
      change_column :emotional_supports, :user_id, :uuid, using: 'user_id::uuid'
    end

    remove_foreign_key :emotional_supports, :users

    add_foreign_key :emotional_supports, :young_people, column: :user_id, primary_key: "user_id"
  end

  private


  def column_for(table_name, column_name)
    ActiveRecord::Base.connection.columns(table_name).find { |c| c.name == column_name.to_s }
  end
end
